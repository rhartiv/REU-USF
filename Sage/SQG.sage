import itertools
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
	OutGate=ID[n-(pos+1)].tensor_product(GateType[1]).tensor_product(ID[pos])
	return(OutGate)

def BuildG(n):
	L=[]
	L2=[]
	for i in range(n):
		L.append([])
		for ii in GateTypes:
			L[i].append(ii[0])
		for ii in itertools.product(*L):
			if sorted(ii) not in L2:
				L2.append(list(ii))
	L3=[]
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
	return(L3)

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