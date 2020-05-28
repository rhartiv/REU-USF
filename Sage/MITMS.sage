# Meet in the Middle (MitM) program

from time import process_time 
import multiprocessing as mp


#  This first function builds a single qubit gate-set. This will be essential in our
#  later parallelization of the MitM function

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
	
	#  First we'll build each single qubit gate from the Clifford+T set on our n
	
	print('Building Single-Qubit Gates')
	for i in range(l):
		Gates.append([GateTypes[i]])
	for i in range(l):
		for ii in range(n): 
			Gates[i].append(Gate(ii,n,Gates[i][0]))
			if Gates[i][0]==X:
					G[0].append('X{}'.format(ii))
					G[1].append(Gates[i][ii+1])
			if Gates[i][0]==Y:
					G[0].append('Y{}'.format(ii))
					G[1].append(Gates[i][ii+1])
			if Gates[i][0]==Z:
					G[0].append('Z{}'.format(ii))
					G[1].append(Gates[i][ii+1])
			if Gates[i][0]==S:
					G[0].append('S{}'.format(ii))
					G[1].append(Gates[i][ii+1])
			if Gates[i][0]==T:
					G[0].append('T{}'.format(ii))
					G[1].append(Gates[i][ii+1])
			if Gates[i][0]==H:
					G[0].append('H{}'.format(ii))
					G[1].append(Gates[i][ii+1])
			print('{}'.format(i/l*100)+'%')
	
	#  And we will add to that set each 2-qubit CNOT gate for our n
	
	print('Adding CNOT Gates')
	for i in range(n):
		for j in range(n):
			if j!=i:
				G[0].append('CNOT({} {})'.format(i,j))
				G[1].append(CNOT(i,j,n))
		print('{}'.format(i/n*100)+'%')
	for i in range(len(G[0])):
		SQGs.append([G[0][i],G[1][i]])
	
	#  Then return our desired gate-set
	
	return SQGs


#  This next function expands the input Optimized list of circuits 'Op' by
#  the input single qubit gate-set 'SQG'. Note, here B will be some deepcopy of the 
#  original circuit list. Only we won't want to copy within this function, rather we'll
#  do so later within the MitM function. 

def ExpandBySQG(Op,B,U,SQG):
	Expand_time_start=process_time()
	k=0
	t1_start=process_time()
	comlen=B[0][0].count(',')
	for j in range(len(B[0])):
		if ((j/len(B[0]))*100)>=(k+25):
			k=k+25
			print('{}'.format(k)+'%')
			
		#  For each unitary in the circuit list, we'll multiply by the SQG unitary
		
		AB=SQG[1]*B[1][j]
		
		if AB==U:
			Op[0].append(SQG[0]+','+B[0][j])
			Op[1].append(AB)	
			break
		
		#  And check if this is equal to our target, for which we will break and return
		if AB in Op[1]:
			if Op[0][Op[1].index(AB)].count(',')==comlen:
				Op[0][Op[1].index(AB)]=SQG[0]+','+B[0][j]
			continue
		else:
			Op[0].append(SQG[0]+','+B[0][j])
			Op[1].append(AB)					
			continue
		break
		
		#  If this product exists within the circuit list, we'll ensure the name of
		#  the circuit reflects each gate used, else add it to the list.
		



	Expand_time_end=process_time()
	print('{}'.format(Expand_time_end-Expand_time_start)+' seconds')
	
	#  And of course, we then return the updated circuit list
	
	return Op
	
#  The next function is the meat and potatoes of this program, the actual Meet in the
#  Middle function. As proposed in Amy's thesis, we'll have inputs of our target Unitary,
#  and the cutoff length at which we should have found a collision. Note, we will build
#  the single qubit gate-set proposed in the thesis using the functions above within
#  this function.

def MitM(U,l):
	
	MitM_time_start=process_time()
	#  We fist determine the number of qubits by observing the size of the target unitary
	
	n=round(log(len(U[0]))/log(2))
	
	#  We'll then start the construction of a starting circuit list of all depth 3
	#  circuits using the function from the CircuitGenerator.sage file, as well as 
	#  construction of the single qubit gate-set by the function above.
	
	CircuitList=Circuit3(n)
	G=BuildG(n)
	
	#  We then test if our target is in the list, and iterate the Expand function above 
	#  until either a collision is found or we reach a depth of l/2
	
	comlen=2
	while comlen< (l/2):
		
		TargetCircuit=0
		
		#  Creating a deepcopy ensures we our copy is unaffected by changing the Circuit list
		
		B=deepcopy(CircuitList)
		comlen=B[0][0].count(',')
		
		#  
		print('No length '+'{}'.format(comlen+1)+' collisions, expanding to length '+'{}'.format(comlen+2))
		for i in range(len(G)):
			if U in CircuitList[1]:
				TargetCircuit=CircuitList[0][CircuitList[1].index(U)]
				break
			else:
				print('No collision found, adding all '+'{}'.format(G[i][0])+' elements')
				ExpandBySQG(CircuitList,B,U,G[i])
				continue
		if type(TargetCircuit)==sage.rings.integer.Integer:
			continue
		break
	MitM_time_end=process_time()
	print('Total process time: '+'{}'.format(MitM_time_end-MitM_time_start)+' seconds')
	
	return TargetCircuit
	

def ParallelMitM(U,l):
	MitM_time_start=process_time()
	n=round(log(len(U[0]))/log(2))
	CircuitList=Circuit3(n)
	G=BuildG(n)
	comlen=2
	while comlen< (l/2):
		TargetCircuit=0
		
		B=deepcopy(CircuitList)
		comlen=B[0][0].count(',')
		
		print('No length '+'{}'.format(comlen+1)+' collisions, expanding to length '+'{}'.format(comlen+2))
		

		pool=mp.Pool(mp.cpu_count())
		CircuitList=[pool.apply(ExpandBySQG, args=(CircuitList,B,U,G[ii])) for ii in range(len(G))]
		pool.close()
		if U in CircuitList[1]:
			TargetCircuit=CircuitList[0][CircuitList[1].index(U)]
			break
		else:
			continue		
		break
	MitM_time_end=process_time()
	print('Total process time: '+'{}'.format(MitM_time_end-MitM_time_start)+' seconds')
	
	return TargetCircuit





def AmplitudeCheck(A,B):
	if 








