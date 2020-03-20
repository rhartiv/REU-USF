from time import process_time 
import random

def Convert(string): 
	li = list(string.split(",")) 
	return li 

def Circuit3(n):
	l=len(GateTypes)
	Gates=[]
	keys=[]
	values=[]
	CircuitKeys=[]
	CircuitValues=[]
	Keys=['Id']
	Values=[matrix.identity(2^n)]
	randomlist=[]
	
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
	print('Optimizing Circuit List')
	m=len(keys)
	k=0
	for i in range(m):
		M=values[i]
		found=False
		for j in range(len(CircuitValues)):
			if M==CircuitValues[j]:
				found=True
				CircuitKeys[j].append(keys[i])
				break
		if found==False:
			CircuitKeys.append([keys[i]])
			CircuitValues.append(M)
		if ((i/m)*100)>=(k+10):
			k=k+10
			print('{}'.format(k)+'%')
		elif ((i/m)*100)>=99:
			print('{}'.format(i/m*100)+'%')
	OptimizedCircuits=[CircuitKeys,CircuitValues]
	t1_end=process_time()
	print('{}'.format(t1_end-t1_start)+' seconds')
	
	#  Performing Sanity Checks
	
	if len(OptimizedCircuits[0])!=len(OptimizedCircuits[1]):                                                
		print('The number of circuits does not match the number of unitaries') 
	else:                                   
		print('The number of circuits matchs the number of unitaries')

	
	lll=0
	for i in range(len(OptimizedCircuits[0])):
		lll=lll+len(OptimizedCircuits[0][i])
	if len(keys)!=lll:
		print('The number of keys for all generated circuits is not equal to the number of keys for the optimized circuits')
	else:
		print('The number of keys for all generated circuits is equal to the number of keys for the optimized circuits')
	
	t2_start=process_time()
	test=copy(OptimizedCircuits[1])                                                          
	k=0
	print('Testing for duplicate unitaries')
	for i in range(len(OptimizedCircuits[1])):
		while OptimizedCircuits[1][len(OptimizedCircuits[1])-(i+1)] in test:
			test.remove(OptimizedCircuits[1][len(OptimizedCircuits[1])-(i+1)])
		if len(test)!=(len(OptimizedCircuits[1])-(i+1)):
			print('There is at least one duplicate unitary: ' '{}'.format(i))
			break
		if (i/len(OptimizedCircuits[1])*100)>=k+10:
			k=k+10
			print('{}'.format(k)+'%')
		if i==(len(OptimizedCircuits[1])-1):
			print('There are no duplicate unitaries')
	t2_end=process_time()
	print('{}'.format(t2_end-t2_start)+' seconds')
	
	print('Testing 500 random keys are equal to their values')
	RandomTests=True
	for i in range(500):
		nn = random.randint(0,(len(OptimizedCircuits[0])-1))
		nnn= random.randint(0,(len(OptimizedCircuits[0][nn])-1))
		randomlist.append(OptimizedCircuits[0][nn][nnn])
		value=OptimizedCircuits[1][nn]
		a=Convert(OptimizedCircuits[0][nn][nnn])
		for ii in range(len(a)):
			a[ii]=Values[Keys.index(a[ii])]
		valuea=a[0]*a[1]*a[2]
		if value!=valuea:
			print(OptimizedCircuits[0][nn][nnn], ' NOT EQUAL TO ', OptimizedCircuits[1][nn])
			RandomTests=False
			break
		else:
			print(OptimizedCircuits[0][nn][nnn], '=', OptimizedCircuits[1][nn])
	if RandomTests==True:
		print('All 500 random tests pass')
	else:
		print('Random test failed')
	
	
	
	return OptimizedCircuits
	
	
	
	
	
	
	
	
	
	
	
	
	
	