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
			x=Id
			y=X
		else:
			x=Id
			y=Id
		XX=XX.tensor_product(x)
		Y=Y.tensor_product(y)
	U=XX+Y
	return(U)

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
	
	print('Building Single-Qubit Gates')
	
	# First we'll make the length one circuits
	L1=[]
	for i in range(n):
		for ii in range(l):
			L1.append(Gate(i,n,GateTypes[ii]))
	
	# Next we'll expand that to all depth one circuits, i.e. single quantum gates
	
	#L2=[]
	#for i in range(len(L1)/2):
	#	L2.append(L1[2*i]+
		
		
	
	#  And we will add to that set each 2-qubit CNOT gate for our n
	
	#print('Adding CNOT Gates')
	#for i in range(n):
	#	for j in range(n):
	#		if j!=i:
	#			G[0].append('CNOT({} {})'.format(i,j))
	#			G[1].append(CNOT(i,j,n))
	#	print('{}'.format(i/n*100)+'%')
	#for i in range(len(G[0])):
	#	SQGs.append([G[0][i],G[1][i]])
	
	#  Then return our desired gate-set
	
	return sorted(L1)