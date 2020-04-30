#  Sanity Checks
from time import process_time 
import random

def Convert(string): 
	li = list(string.split(",")) 
	return li 

def SanityChecks(Optimizedircuits):
	if len(OptimizedCircuits[0])!=len(OptimizedCircuits[1]):                                                
		print('The number of circuits does not match the number of unitaries') 
	else:                                   
		print('The number of circuits matchs the number of unitaries')

	l=len(GateTypes)
	Gates=[]
	keys=[]
	values=[]
	Keys=['Id']
	Values=[matrix.identity(2^n)]
	randomlist=[]
	
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
	for i in range(n):
		for j in range(n):
			if j!=i:
				Keys.append('CNOT({} {})'.format(i,j))
				Values.append(CNOT(i,j,n))
		print('{}'.format(i/n*100)+'%')
	ll=len(Keys)
	for i in range(ll):
		for j in range(ll):
			for k in range(ll):
				keys.append(Keys[i]+','+Keys[j]+','+Keys[k])
				values.append(Values[i]*Values[j]*Values[k])
	
	
	
	## GENERAL SIZE CHECK
	
	lll=0
	for i in range(len(OptimizedCircuits[0])):
		lll=lll+len(OptimizedCircuits[0][i])
	if len(keys)!=lll:
		print('The number of keys for all generated circuits is not equal to the number of keys for the optimized circuits')
	else:
		print('The number of keys for all generated circuits is equal to the number of keys for the optimized circuits')
	
	
	
	## UNIQUENESS OF UNITARIES CHECK
	
	t1_start=process_time()
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
	t1_end=process_time()
	print('{}'.format(t2_end-t2_start)+' seconds')
	
	
	
	## RANDOM VALUE CHECK
		
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
		
	
		
##  APPEDND DIFFICULTY CHECK

def AppendDifficulty(n):
	array=[]
	avgtime=[]
	for i in range(n):
		RM=random_matrix(CDF,4,4)
		time_start=process_time()
		array.append(RM)
		time_end=process_time()
		time=time_end-time_start
		avgtime.append(time)
	
	return mean(avgtime)
	

## COMPLEX MATRIX MULTIPLICATION DIFFICULTY

def CompMultDiff(n):
	array=[]
	avgtime=[]
	for i in range(n):
		RM1=random_matrix(CDF,4,4)
		RM2=random_matrix(CDF,4,4)
		time_start=process_time()
		RM1*RM2
		time_end=process_time()
		time=time_end-time_start
		avgtime.append(time)
	
	return [mean(avgtime),time]
	
## CHECK LIST FOR COMPLEX MATRIX DIFFICULTY

def CompSearchList(n):
	array=[]
	avgtime=[]
	for i in range(n):
		RM=random_matrix(CDF,4,4)
		time_start=process_time()
		if (RM in array)==False:
			array.append(RM)
		time_end=process_time()
		time=time_end-time_start
		avgtime.append(time)
	
	return [mean(avgtime),time]
	
## CHECK DICTIONARY FOR COMPLEX MATRIX DICFFICULTY

def CompSearchDict(n):
	Dict={}
	avgtime=[]
	for i in range(n):
		RM=random_matrix(CDF,4,4)
		time_start=process_time()
		if (RM in Dict.values())==False:
			Dict[i]=RM
		time_end=process_time()
		time=time_end-time_start
		avgtime.append(time)
	
	return [mean(avgtime),time]

