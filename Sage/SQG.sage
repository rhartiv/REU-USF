import itertools

## Here are Listed Common Gates as Lists With Their Names as a String and Their Unitaries as a Matrix
H=['H',(1/sqrt(2))*matrix([[1,1],[1,-1]])]
X=['X',matrix([[0,1],[1,0]])]
Y=['Y',matrix([[0,-I],[I,0]])]
Z=['Z',matrix([[1,0],[0,-1]])]
S=['S',matrix([[1,0],[0,I]])]
T=['T',matrix([[1,0],[0,(1/2*I + 1/2)*sqrt(2)]])]
Toffoli=['Toffoli',matrix([[1,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0],[0,0,1,0,0,0,0,0],[0,0,0,1,0,0,0,0],[0,0,0,0,1,0,0,0],[0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,1],[0,0,0,0,0,0,1,0]])]
Id=['Id',matrix.identity(2)]
GateTypes=sorted([H,S])
X0=['X0',Id[1].tensor_product(Id[1].tensor_product(Id[1].tensor_product(X[1])))]
X0[1].set_immutable()

## This Function Creates the CNOT Gate Unitary for Target i and Control j on n Qubits
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

## This Function Will Take Any Gate Type and Place it on The Specified Wire Position, Returning the Unitary
def Gate(pos,n,GateType):
	ID=[matrix([1])]
	for i in range(n):
		ID.append(i)
		ID[i+1]=ID[i].tensor_product(Id[1])
	OutGate=ID[n-(pos+1)].tensor_product(GateType[1]).tensor_product(ID[pos])
	return(OutGate)

## This Function Will Create a List of Single-Quantum-Gates (i.e. Depth-1 Circuits up to Gate-Count n)
def BuildG(n):
	L=[]
	L2=[]
	# Cartesian Product of the Gate Types
	for i in range(n):
		L.append([])
		for ii in GateTypes:
			L[i].append(ii[0])
		for ii in itertools.product(*L):
			if sorted(ii) not in L2:
				L2.append(list(ii))
	L3=[]
	# Joining the Unique Sets of Cartesian Products
	for i in range(len(L2)):
		NumOfGates=len(L2[i])
		SQG=matrix.identity(2^n)
		for ii in range(NumOfGates):
			pos=ii
			for iii in range(len(GateTypes)):
				if L2[i][ii] in GateTypes[iii]:
					G=Gate(pos,n,GateTypes[iii])
			SQG=SQG*G
		L3.append([''.join(L2[i]),SQG])
	
	G=[[],[]]
	# Adding CNOT Gates
	for i in range(n):
		for j in range(n):
			if j!=i:
				G[0].append('CNOT({} {})'.format(i,j))
				G[1].append(CNOT(i,j,n))
	for i in range(len(G[0])):
		L3.append([G[0][i],G[1][i]])
	L3.append(['Id',Gate(0,n,Id)])
	return(sorted(L3))

## This Function Creates a Dictionary From a Given List (say of BuildG)
def CircuitList(G):
	d={}
	for i in G:
		i[1].set_immutable()
		d[i[1]]=i[0]
	return(d)