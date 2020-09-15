H=['H',(1/sqrt(2))*matrix([[1,1],[1,-1]])]
X=['X',matrix([[0,1],[1,0]])]
Y=['Y',matrix([[0,-I],[I,0]])]
Z=['Z',matrix([[1,0],[0,-1]])]
S=['S',matrix([[1,0],[0,I]])]
T=['T',matrix([[1,0],[0,(1/2*I + 1/2)*sqrt(2)]])]
Toffoli=['Toffoli',matrix([[1,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0],[0,0,1,0,0,0,0,0],[0,0,0,1,0,0,0,0],[0,0,0,0,1,0,0,0],[0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,1],[0,0,0,0,0,0,1,0]])]
Id=['Id',matrix.identity(2)]
# GateTypes=[X,Y,Z,S,T,H]
GateTypes=sorted([H,S])
X0=['X0',Id[1].tensor_product(X[1])]
X0[1].set_immutable()


def Gate(pos,n,GateType):
	ID=[matrix([1])]
	for i in range(n):
		ID.append(i)
		ID[i+1]=ID[i].tensor_product(Id[1])
	OutGate=[GateType[0]+'{}'.format(pos),ID[n-(pos+1)].tensor_product(GateType[1]).tensor_product(ID[pos])]
	return(OutGate)

def CNOT(i,j,n):
	i=n-i-1
	j=n-j-1
	XX=matrix([1])
	Y=matrix([1])
	zero=vector([1,0])
	one=vector([0,1])
	for ii in range(n):
		if ii==i:
			x=zero.outer_product(zero)
			y=one.outer_product(one)
		elif ii==j:
			x=Id[1]
			y=X[1]
		else:
			x=Id[1]
			y=Id[1]
		XX=XX.tensor_product(x)
		Y=Y.tensor_product(y)
	U=XX+Y
	return(U)
	
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

def BuildG(n):
	
	#  n is the input number of qubits,
	#  GateTypes are standard Clifford+T gates, located in the Gates.sage file
	
	l=len(GateTypes)
	
	print('Building Single-Qubit Gates')
	
	# First we'll make the length one circuits
	L1=[['Id',matrix.identity(2^n)]]
	for i in range(n):
		for ii in range(l):
			L1.append(Gate(i,n,GateTypes[ii]))
	


	L=[['Id',matrix.identity(2^n)]]       
	P=PermMatrices(n)
	LMats=[matrix.identity(2^n)]
	for i in range(len(L1)):
		for ii in range(len(L1)):
			flag=0
			TestElement=[L1[i][0]+L1[ii][0],L1[i][1]*L1[ii][1]]
			count=[]
			for nn in range(n):
				count.append(TestElement[0].count('{}'.format(nn)))
			for iii in count:
				if iii>1:
					flag=1
			if flag==0:
				flag2=0
				for pp in P:
					perm=TestElement[1]*pp
					if perm in LMats:
						if perm!=TestElement[1]:
							flag2=1
				if flag2==0:
					L.append([L1[i][0]+L1[ii][0],Product])
					LMats.append(Product)

	
	return sorted(L)