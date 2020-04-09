# Meet in the middle program

from time import process_time 
import multiprocessing as mp


def BuildA(Op):
	l=len(GateTypes)
	n=round(log(len(Op[1][0][0]))/log(2))
	Gates=[]
	A=[]
	A.append(['Id'])
	A.append([matrix.identity(2^n)])
	SQGs=[]
	
	print('Building Single-Qubit Gates')
	for i in range(l):
		Gates.append([GateTypes[i]])
	for i in range(l):
		for ii in range(n): 
			Gates[i].append(Gate(ii,n,Gates[i][0]))
			if Gates[i][0]==X:
					A[0].append('X{}'.format(ii))
					A[1].append(Gates[i][ii+1])
			if Gates[i][0]==Y:
					A[0].append('Y{}'.format(ii))
					A[1].append(Gates[i][ii+1])
			if Gates[i][0]==Z:
					A[0].append('Z{}'.format(ii))
					A[1].append(Gates[i][ii+1])
			if Gates[i][0]==S:
					A[0].append('S{}'.format(ii))
					A[1].append(Gates[i][ii+1])
			if Gates[i][0]==T:
					A[0].append('T{}'.format(ii))
					A[1].append(Gates[i][ii+1])
			if Gates[i][0]==H:
					A[0].append('H{}'.format(ii))
					A[1].append(Gates[i][ii+1])
			print('{}'.format(i/l*100)+'%')
	print('Adding CNOT Gates')
	for i in range(n):
		for j in range(n):
			if j!=i:
				A[0].append('CNOT({} {})'.format(i,j))
				A[1].append(CNOT(i,j,n))
		print('{}'.format(i/n*100)+'%')
	for i in range(len(A[0])):
		SQGs.append([A[0][i],A[1][i]])
	return SQGs
	

def expandby1(Op,SQG):

	B=deepcopy(Op)
	comlen=Op[0][0].count(',')
	k=0
	ii=1
	t1_start=process_time()

	for j in range(len(B[0])):
		AB=SingleQubitGate[1]*B[1][j]
		if AB in Op[1]:
			if Op[0][Op[1].index(AB)].count(',')==comlen:
				Op[0][Op[1].index(AB)]=SQG[0]+','+B[0][j]
		else:
			Op[0].insert(ii,SQG[0]+','+B[0][j])
			Op[1].insert(ii,AB)
			ii=ii+1
		if ((j/len(B[0]))*100)>=(k+5):
			k=k+5
			print('{}'.format(k)+'%')
		elif ((j/len(B[0]))*100)>=99:
			print('{}'.format(i/len(B[0])*100)+'%')
	t1_end=process_time()
	print('{}'.format(t1_end-t1_start)+' seconds')
	
	

	
	
	
	
	
	