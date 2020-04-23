## GENERATOR OF LENGTH 3 

from time import process_time 
import multiprocessing as mp


def Circuit3(n):
	l=len(GateTypes)
	Gates=[]
	keys=[]
	values=[]
	CircuitKeys=[]
	CircuitValues=[]
	Keys=['Id']
	Values=[matrix.identity(2^n)]
	
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
	print('Building All Circuits of Length 3')
	ll=len(Keys)
	for i in range(ll):
		for j in range(ll):
			for k in range(ll):
				keys.append(Keys[i]+','+Keys[j]+','+Keys[k])
				values.append(Values[i]*Values[j]*Values[k])
		print('{}'.format(i/ll*100)+'%')
		
	t1_start=process_time()
	print('Optimizing length 3 circuit list')
	m=len(keys)
	k=0
	for i in range(m):
		if ((i/m)*100)>=(k+10):
			k=k+10
			print('{}'.format(k)+'%')
		elif ((i/m)*100)>=99:
			print('{}'.format(i/m*100)+'%')
		M=values[i]
		if M in CircuitValues:
			continue
		else:
			CircuitKeys.append(keys[i])
			CircuitValues.append(M)
	OptimizedCircuits=[CircuitKeys,CircuitValues]
	t1_end=process_time()
	print('{}'.format(t1_end-t1_start)+' seconds')
	
	return OptimizedCircuits
	
	
def GenLen3Circuits(n):

	pool=mp.Pool(mp.cpu_count())
	Op=pool.map(Circuit3, [n])
	pool.close()
	
	return Op[0]
	
	
