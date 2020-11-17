##  New MitM
import itertools
from time import time


##  List of common gates as a list containing their standard symbol and single-qubit unitaries
H=['H',(1/sqrt(2))*matrix([[1,1],[1,-1]])]
X=['X',matrix([[0,1],[1,0]])]
Y=['Y',matrix([[0,-I],[I,0]])]
Z=['Z',matrix([[1,0],[0,-1]])]
S=['S',matrix([[1,0],[0,I]])]
T=['T',matrix([[1,0],[0,(1/2*I + 1/2)*sqrt(2)]])]
Toffoli=['Toffoli',matrix([[1,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0],[0,0,1,0,0,0,0,0],[0,0,0,1,0,0,0,0],[0,0,0,0,1,0,0,0],[0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,1],[0,0,0,0,0,0,1,0]])]
Id=['Id',matrix.identity(2)]
GateTypes=sorted([H,S])


## Also defining a 2-qubit quantum circuit for which an X gate resides on the first register, for search/testing purposes
X0=['X0',X[1]]
X0[1].set_immutable()


## This Function Creates the CNOT Gate Unitary for Target i and Control j on n Qubits
def CNOT(i,j,n):
	##  We need to adjust for the python indexing standards
	i=n-i-1
	j=n-j-1
	##  And initialize the matrices/vectors which we will manipulate throughout, XX will represent 
	##        the entries for identity outputs, and Y for flipped outputs
	XX=matrix([1])
	Y=matrix([1])
	zero=vector([1,0])
	one=vector([0,1])
	##  Now we iterate to place each matrix in the correct position of the tensor product order
	for ii in range(n):
		##  When we hit the target we take outer products of the two computational basis vectors 
		##        with themselves
		if ii==i:
			x=zero.outer_product(zero)
			y=one.outer_product(one)
		##  When we hit the control we take the identity for x component (to be used on XX generation),
		##        and the bitflip or X gate on for the y component (to be used on Y generation)
		elif ii==j:
			x=Id[1]
			y=X[1]
		##  If neither control nor target we simply want identity matrices for each
		else:
			x=Id[1]
			y=Id[1]
		##  At the end of each iteration we take a tensor product with the proper matrix at that level
		XX=XX.tensor_product(x)
		Y=Y.tensor_product(y)
	##  Lastly we combine the possible matrices to one unitary and return it
	return(XX+Y)


##  This function takes one of the single qubit gates defined above and places it on a specified wire
##        position, returning the unitary
def Gate(pos,n,GateType):
	##  Initialize a singular matrix
	ID=[matrix([1])]
	##  Create a list of identity matrices of different sizes
	for i in range(n):
		ID.append(i)
		ID[i+1]=ID[i].tensor_product(Id[1])
	##  The gate final will be some size identity matrix tensor product single qubit gate tensor product
	##        some (possibly different) size identity matrix
	OutGate=ID[pos].tensor_product(GateType[1]).tensor_product(ID[n-(pos+1)])
	return(OutGate)
	
	
##  This Function Will Create a List of Single-Quantum-Gates (i.e. Depth-1 Circuits up to Gate-Count n)
def BuildG(n):
	##  First we initialize some temporary lists
	L=[]
	L2=[]
	L3=[['Id',Gate(0,n,Id)]]
	##  Ensuring we consider the conjugate, transpose of each of our considered unitaries
	for i in range(len(GateTypes)):
		Conjugate=[GateTypes[i][0]+"*", conjugate(transpose(GateTypes[i][1]))]
		GateTypes.append(Conjugate)
	##  Cartesian Product of the Gate Types
	for i in range(n):
		L.append([])
		for ii in GateTypes:
			L[i].append(ii[0])
		for ii in itertools.product(*L):
			if sorted(ii) not in L2:
				L2.append(list(ii))
	##  Joining unique sets of cartesian products, separated by a space
	for i in range(len(L2)):
		NumOfGates=len(L2[i])
		SQG=matrix.identity(2^n)
		for ii in range(NumOfGates):
			pos=ii
			for iii in range(len(GateTypes)):
				if L2[i][ii] in GateTypes[iii]:
					G=Gate(pos,n,GateTypes[iii])
			SQG=SQG*G
		flag=True
		for ii in L3:
			if (SQG in ii)==True:
				flag=False
		if flag==True:
			L3.append([''.join(L2[i]),SQG])
	G=[[],[]]
	##  Adding CNOT Gates
	for i in range(n):
		for j in range(n):
			if j!=i:
				G[0].append('CNOT({} {})'.format(i,j))
				G[1].append(CNOT(i,j,n))
	for i in range(len(G[0])):
		L3.append([G[0][i],G[1][i]])
	return(sorted(L3))


##  This function takes a string of a circuit and returns the unitary, given that it has G (a list of SQGs)
def StrToUnitary(str,G):
	##  Initialize the final unitary
	for i in G:
		if 'Id' in i:
			Unitary=G[G.index(i)][1]
	##  Split the string according to circuit depth, delimited by a comma
	L=str.split(',')
	##  Calculate the unitary at each step of the circuit and return the final unitary
	for i in L:
		for ii in G:
			if i in ii:
				Item=G[G.index(ii)][1]
		Unitary=Item*Unitary
	return(Unitary)


##  This function will take a list of circuit-strings and a given unitary, and return a True/False valuation
##        as to whether or not the unitary is contained in the list
def TestCircuitList(CircuitList,U,G):
	##  Setting a boolean test
	flag=False
	##  Iterating through all circuits in the list
	for i in CircuitList:
		Unit=StrToUnitary(i,G)
		if U==Unit:
			flag=True
			break
	return(flag)


##  This function will take a list of circuit-strings and a single quantum gate, and return a list of unique
##        circuit-strings which were not in the original list
@parallel(16)
def ExpandBySQG(CircuitList,SQG,G):
	##  Initialize output list
	L=[]
	##  Iterate through the circuit list and add new circuit strings to the final list
	for i in CircuitList:
		Prod=SQG[1]*StrToUnitary(i,G)
		if TestCircuitList(CircuitList,Prod,G)==False:
			L.append(i+','+SQG[0])
	return(L)


##  This function takes a list of lists of circuit-strings and returns only a single list of unique circuit strings
def EnsureUnique(lst,G):
	##  Initialize final list
	L=[]
	##  Iterate adding only new items to the list
	for i in lst:
		for ii in i:
			if TestCircuitList(L,StrToUnitary(ii,G),G)==False:
				L.append(ii)
	return(L)


##  Next we define the common SWAP function, which is just an implementation of 3 CNOTs over specified wires
def SWAP(i,j,n):
	U=CNOT(i,j,n)*CNOT(j,i,n)*CNOT(i,j,n)
	return(U)


##  This function creates all permutation matrices for swaps on n wires
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


##  This function creates a list of tuples for ExpandBySQG use within a parallel decorator
def TupleG(CircuitList,G):
	TupleList=[]
	for i in G:
		Tuple=tuple([CircuitList,i,G])
		TupleList.append(Tuple)
	return TupleList


##  This function finds important values of a target unitary U, up to a relative phase
def FindOnes(U):
	Ones=[]
	n=len(list(U))
	for i in range(n):
		for ii in range(n):
			if abs(U[i][ii])==1:
				Ones.append([i,ii])
	return Ones


##  This function tests the equivalence of a matrix with the important values in l
def TME(U,l):
	# Here U is an input unitary, and l is a list of indices 
	test=true
	for i in range(len(l)):
		if abs(U[l[i][0]][l[i][1]])!=1:
			test=false
			break
	if U==matrix.identity(len(list(U))):
		test=false
	return test


##  Finally, we have the meet in the middle protocol. Here we input a target unitary U and a depth d, and we
##        return the circuit-strings which match the unitary (up to phase)
def MitM(U,d):
	P=PermMatrices(log(len(U[0]),2))
	G=BuildG(log(len(U[0]),2))
	Circuits=[]
	for i in G:
		Circuits.append(i[0])
	Circuits=sorted(EnsureUnique([Circuits],G))
	l=FindOnes(U)
	TargetCircuits=[]
	length=0
	while length<(d-1):
		Tuples=TupleG(Circuits,G)
		UpdaterList=[]
		for Input,Output in sorted(list(ExpandBySQG(Tuples))): UpdaterList.append(Output)
		Circuits=sorted(Circuits+EnsureUnique(UpdaterList,G))
		for i in range(len(P)):
			for ii in Circuits:
				Pii=P[i]*StrToUnitary(ii,G)*P[i]
				Pii.set_immutable()
				if TME(Pii,l)==true:
					if ii not in TargetCircuits:
						TargetCircuits.append(ii)
				else:
					continue
		length += 1
	return(TargetCircuits)



		
		