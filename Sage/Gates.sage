H=(1/sqrt(2))*matrix([[1,1],[1,-1]])
X=matrix([[0,1],[1,0]])
Y=matrix([[0,-I],[I,0]])
Z=matrix([[1,0],[0,-1]])
S=matrix([[1,0],[0,I]])
T=matrix([[1,0],[0,exp(I*pi()/4)]])
Toffoli=matrix([[1,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0],[0,0,1,0,0,0,0,0],[0,0,0,1,0,0,0,0],[0,0,0,0,1,0,0,0],[0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,1],[0,0,0,0,0,0,1,0]])
Id=matrix.identity(2)
# GateTypes=[X,Y,Z,S,T,H]
GateTypes=[S,H]
X0=Id.tensor_product(X)
X0.set_immutable()


def Gate(pos,n,GateType):
	ID=[matrix([1])]
	for i in range(n):
		ID.append(i)
		ID[i+1]=ID[i].tensor_product(Id)
	OutGate=ID[n-(pos+1)].tensor_product(GateType).tensor_product(ID[pos])
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

#  Here is an older version of the CNOT I made which doesn't utilize 
#  the outer_product sage command:

def OldCNOT(i,j,n):
	#  Building initial vectors
	v={}
	for ii in range(0,2^n):
		v["{0:b}".format(ii)]=matrix(1,2^n,{(0,ii):1})

	#  Selecting control vectors
	c={}
	ccount=n-i
	for ii in range(0,2^(n-1)/(2^(ccount-1))):
		for iii in range(0,2^(ccount-1)):
			c["{0:b}".format(2^ccount*ii+(2^(ccount-1)+iii))]=v["{0:b}".format(2^ccount*ii+(2^(ccount-1)+iii))]
	
	#  Building target-send function
	tindex=[0]
	for ii in range(1,n):
		tindex.append(ii)
	tindex.remove(i)
	jindex=tindex.index(j)+1
	k=n-jindex
	
	#  Defining a swap function for elements of a list
	def swapPositions(list, pos1, pos2): 
		get = list[pos1], list[pos2] 
		list[pos2], list[pos1] = get 
		return list
		
	f=list(c)
	initswap=[0]
	for ii in range(0,2^(jindex-1)):
		for iii in range(0,2^(k-1)):
			initswap.append(2^(k)*ii+iii)
	initswap.remove(0)
	
	for ii in initswap:
		g=swapPositions(f,ii,ii+2^(k-1))
	
	#create target vectors and matrix
	t={}
	for ii in range(2^(n-1)):
		t[list(c)[ii]]=c[g[ii]]
	
	for ii in t:
		v[ii]=t[ii]
	
	U=matrix(1,2^n,0)
	for ii in range(0,2^n):
		U=U.insert_row(ii+1,v["{0:b}".format(ii)].row(0))
	U=U.delete_rows([0])
	return U
