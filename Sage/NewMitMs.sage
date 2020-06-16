from time import process_time 

# NEW parallel MitM using dictionaries instead of lists
def BuildG(n):
	
	#  n is the input number of qubits,
	#  GateTypes are standard Clifford+T gates, located in the Gates.sage file
	
	l=len(GateTypes)
	# n=round(log(len(Op[1][0][0]))/log(2))
	Gates=[]
	G=[]
	G.append(['Id'])
	G.append([matrix.identity(2^n)])
	SQGs=[]
	
	#  First we'll build each single qubit gate from the Clifford+T set on our n
	
	print('Building Single-Qubit Gates')
	for i in range(l):
		Gates.append([GateTypes[i]])
	for i in range(l):
		for ii in range(n): 
			Gates[i].append(Gate(ii,n,Gates[i][0]))
			if Gates[i][0]==X:
					G[0].append('X{}'.format(ii))
					G[1].append(Gates[i][ii+1])
			if Gates[i][0]==Y:
					G[0].append('Y{}'.format(ii))
					G[1].append(Gates[i][ii+1])
			if Gates[i][0]==Z:
					G[0].append('Z{}'.format(ii))
					G[1].append(Gates[i][ii+1])
			if Gates[i][0]==S:
					G[0].append('S{}'.format(ii))
					G[1].append(Gates[i][ii+1])
			if Gates[i][0]==T:
					G[0].append('T{}'.format(ii))
					G[1].append(Gates[i][ii+1])
			if Gates[i][0]==H:
					G[0].append('H{}'.format(ii))
					G[1].append(Gates[i][ii+1])
			print('{}'.format(i/l*100)+'%')
	
	#  And we will add to that set each 2-qubit CNOT gate for our n
	
	print('Adding CNOT Gates')
	for i in range(n):
		for j in range(n):
			if j!=i:
				G[0].append('CNOT({} {})'.format(i,j))
				G[1].append(CNOT(i,j,n))
		print('{}'.format(i/n*100)+'%')
	for i in range(len(G[0])):
		SQGs.append([G[0][i],G[1][i]])
	
	#  Then return our desired gate-set
	
	return sorted(SQGs)
	
def TupleG(G,A,B,U):
	TupleList=[]
	for i in G:
		Tuple=tuple([i,A,B,U])
		TupleList.append(Tuple)
		
	return TupleList
		

@parallel
def ExpandBySQG(SQG,Op,B,U):
	Expand_time_start=process_time()
	k=0
	comlen=B[1].count(',')
	tracker=list(B.values())
	n=round(log(len(U[0]))/log(2))
	P=PermMatrices(n)
	for i in B:
		if ((tracker.index(B[i])/len(tracker))*100)>=(k+25):
			k=k+25
			print('{}'.format(k)+'%')
		
		AB=SQG[1]*i
		AB.set_immutable()
		
		for ii in range(len(P)):
			PAB=P[ii]*AB*P[ii]
			PAB.set_immutable()
			
			if PAB in Op:
				if Op[AB].count(',')==comlen:
					Op[AB]=SQG[0]+','+B[i]
			else:
				Op[AB]=SQG[0]+','+B[i]
			if PAB==U:
				break
		if PAB==U:
			break
	Expand_time_end=process_time()
	print('{}'.format(Expand_time_end-Expand_time_start)+' seconds')

	return Op

def MitM(U,l):
	MitM_time_start=process_time()
	n=round(log(len(U[0]))/log(2))
	P=PermMatrices(n)
	CircuitList=Circuit3(n)
	G=BuildG(n)
	comlen=2
	while comlen< (l/2):
		TargetCircuit=0
		B=deepcopy(CircuitList)
		Tuples=TupleG(G,CircuitList,B,U)
		comlen=B[1].count(',')
		for X,Y in sorted(list(ExpandBySQG(Tuples))): CircuitList.update(Y)
		for i in range(len(P)):
			for ii in CircuitList:
				Pii=P[i]*ii*P[i]
				Pii.set_immutable()
				if U==Pii:
					TargetCircuit=CircuitList[Pii]
					break
				else:
					continue
			if TargetCircuit==0:
				continue
			else:
				break
		if TargetCircuit==0:
			continue
		else:
			break
	MitM_time_end=process_time()
	print('Total process time: '+'{}'.format(MitM_time_end-MitM_time_start)+' seconds')
	
	return TargetCircuit
