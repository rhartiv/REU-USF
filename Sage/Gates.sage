H=(1/sqrt(2))*matrix([[1,1],[1,-1]])
CNOT=matrix([[1,0,0,0],[0,1,0,0],[0,0,0,1],[0,0,1,0]])
X=matrix([[0,1],[1,0]])
Y=matrix([[0,-i],[i,0]])
Z=matrix([[1,0],[0,-1]])
S=matrix([[1,0],[0,i]])
T=matrix([[1,0],[0,exp(i*pi()/4)]])
Toffoli=matrix([[1,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0],[0,0,1,0,0,0,0,0],[0,0,0,1,0,0,0,0],[0,0,0,0,1,0,0,0],[0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,1],[0,0,0,0,0,0,1,0]])
Id=matrix.identity(2)

def CNOT(i,j,n):
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
