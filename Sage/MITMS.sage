from time import time

# NEW parallel MitM using dictionaries instead of lists
def SWAP(i,j,n):
	U=CNOT(i,j,n)*CNOT(j,i,n)*CNOT(i,j,n)
	return(U)

def PermMatrices(n):
	IdElem=matrix.identity(2^n)
	FinalList=[]
	cycles=[]
	swaps=[]
	ProductList=[]
	
	Perms=list(Permutations(n))
	for i in range(len(Perms)):
		cycles.append(Perms[i].cycle_tuples())
	for i in range(len(cycles)):
		swaps.append([])
		for ii in range(len(cycles[i])):
			if len(cycles[i][ii])==2:
				swaps[i].append(cycles[i][ii])
			elif len(cycles[i][ii])>2:
				for iii in range(len(cycles[i][ii])-1):
					swaps[i].append((cycles[i][ii][iii],cycles[i][ii][iii+1]))
	
	for i in range(len(swaps)):
		FinalList.append(IdElem)
		for ii in range(len(swaps[i])):
			FinalList[i]=SWAP(swaps[i][ii][0]-1,swaps[i][ii][1]-1,n)*FinalList[i]
	
	return(FinalList)
	
def TupleG(G,A,CopyCircuits,Target):
	TupleList=[]
	for i in G:
		Tuple=tuple([i,A,CopyCircuits,Target])
		TupleList.append(Tuple)
		
	return TupleList
		
def FindOnes(Target,a):
	# Here a is the number of ancillae 
	Ones=[]
	n=len(list(Target))/(2^a)
	for i in range(n):
		for ii in range(n):
			if abs(Target[i][ii])==1:
				Ones.append([i,ii])
	return Ones

def TME(A,l):
	# Here A is an input unitary, and l is a list of indices 
	test=true
	for i in range(len(l)):
		if abs(A[l[i][0]][l[i][1]])!=1:
			test=false
			break
	if A==matrix.identity(len(list(A))):
		test=false
	return test
	
	
# ExpandBySQG
@parallel(4)
def ExpandBySQG(SQG,dict,copydict,Target):
	P=PermMatrices(round(log(len(Target[0]))/log(2)))
	for i in copydict:
		AB=SQG[1]*i
		AB.set_immutable()
		flag=0
		for ii in P:
			if AB*ii==Target:
				flag=1
				break
		
		if AB not in dict:
			dict[AB]=SQG[0]+','+copydict[i]
		if flag==1:
			break
	return(dict)

def MitM(Target,a,depth):
	P=PermMatrices(round(log(len(Target[0]))/log(2)))
	G=BuildG(round(log(len(Target[0]))/log(2)))
	Circuits=CircuitList(G)
	l=FindOnes(Target,a)
	TargetCircuits=[]
	comlen=0
	while comlen<(depth-1):
		CopyCircuits=deepcopy(Circuits)
		Tuples=TupleG(G,Circuits,CopyCircuits,Target)
		for X,Y in sorted(list(ExpandBySQG(Tuples))): Circuits.update(Y)
		for i in range(len(P)):
			for ii in Circuits:
				Pii=P[i]*ii*P[i]
				Pii.set_immutable()
				if TME(Pii,l)==true:
					if Circuits[Pii] not in TargetCircuits:
						TargetCircuits.append(Circuits[Pii])
				else:
					continue
		comlen += 1
	return TargetCircuits
