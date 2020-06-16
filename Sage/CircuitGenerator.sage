## GENERATOR OF LENGTH 3 

from time import process_time


def Circuit3(n):
	t1_start=process_time()
	l=len(GateTypes)
	Gates=[]
	keys=[]
	values=[]
	
	FinalCircuits={}
	Keys=['Id']
	Values=[matrix.identity(2^n)]
	PM=PermMatrices(n)
	
	print('Building Single-Qubit Gates')
	for i in range(l):
		Gates.append([GateTypes[i]])
	for i in range(l):
		for ii in range(n): 
			Gates[i].append(Gate(ii,n,Gates[i][0]))
			if Gates[i][0]==X:
					Keys.append('X{}'.format(ii))
					Values.append(Gates[i][ii+1])
			if Gates[i][0]==Y:
					Keys.append('Y{}'.format(ii))
					Values.append(Gates[i][ii+1])
			if Gates[i][0]==Z:
					Keys.append('Z{}'.format(ii))
					Values.append(Gates[i][ii+1])
			if Gates[i][0]==S:
					Keys.append('S{}'.format(ii))
					Values.append(Gates[i][ii+1])
			if Gates[i][0]==T:
					Keys.append('T{}'.format(ii))
					Values.append(Gates[i][ii+1])
			if Gates[i][0]==conjugate(transpose(T)):
					Keys.append('T^{}'.format(ii))
					Values.append(Gates[i][ii+1])
			if Gates[i][0]==H:
					Keys.append('H{}'.format(ii))
					Values.append(Gates[i][ii+1])
			print('{}'.format(i/l*100)+'%')
	print('Adding CNOT Gates')
	for i in range(n):
		for j in range(n):
			if j!=i:
				Keys.append('CNOT({} {})'.format(i,j))
				Values.append(CNOT(i,j,n))
		print('{}'.format(i/n*100)+'%')
	print('Building List of Length 3 Circuits')
	ll=len(Keys)
	
	for i in range(ll):
		for j in range(ll):
			for k in range(ll):
				Flag=0
				M=Values[i]*Values[j]*Values[k]
				M.set_immutable()
				Label=Keys[i]+','+Keys[j]+','+Keys[k]
				for l in range(len(PM)):
					PMM=PM[l]*M*PM[l]
					PMM.set_immutable()
					if PMM in FinalCircuits:
						Flag=1
				if Flag==0:
					FinalCircuits[M]=Label
		print('{}'.format(i/ll*100)+'%')
	t1_stop=process_time()
	print('{}'.format(t1_stop-t1_start)+' seconds')
	
	return FinalCircuits
	
	
