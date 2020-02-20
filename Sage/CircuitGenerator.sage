## Generator of all length 3 circuits using common gates from the Gates.sage file,
## for an input of "n" qubits.

#test n=3,4,...
n=3
Gates=[H,X,Y,Z,S,T]
fGates=[]
ID=[matrix([1])]

for i in range(n):
	ID.append(i)
	ID[i+1]=ID[i].tensor_product(Id)
for i in range(n):
	for ii in range(len(Gates)):
		fGates.append(ii)
for i in range(n):
	for ii in range(len(Gates)):	
		fGates[n*ii+i]=(ID[i].tensor_product(Gates[ii])).tensor_product(ID[n-(i+1)])
		
for i in range(n):
	for j in range(n):
		if j!=i:
			fGates.append(CNOT(i,j,n))