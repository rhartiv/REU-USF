# Meet in the middle program

from time import process_time 

n=2
Op=Circuit3(n)
A=copy(Op)
B=copy(Op)
comlen=2
k=0
ii=0

t1_start=process_time()
for i in range(len(A[0])):
	if ((i/len(A[0]))*100)>=(k+10):
		k=k+10
		print('{}'.format(k)+'%')
	elif ((i/len(A[0]))*100)>=99:
		print('{}'.format(i/len(A[0])*100)+'%')
	ii=ii+1
	for j in range(len(B[0])):
		AB=A[1][i]*B[1][j]
		if AB in Op[1]:
			if Op[0][Op[1].index(AB)].count(',')==comlen:
				Op[0][Op[1].index(AB)]=[A[0][i][0]+','+B[0][j][0]]
		else:
			Op[0].insert(ii,[A[0][i][0]+','+B[0][j][0]])
			Op[1].insert(ii,AB)
			ii=ii+1
t1_end=process_time()
print('{}'.format(t1_end-t1_start)+' seconds')





	n=2
	Op=Circuit3(n)
	A=deepcopy(Op)
	B=deepcopy(Op)
	comlen=2
	k=0
	ii=1
	t1_start=process_time()

	for j in range(len(B[0])):
		AB=A[1][0]*B[1][j]
		if AB in Op[1]:
			if Op[0][Op[1].index(AB)][0].count(',')==comlen:
				Op[0][Op[1].index(AB)]=[A[0][0][0]+','+B[0][j][0]]
		else:
			Op[0].insert(1,[A[0][0][0]+','+B[0][j][0]])
			Op[1].insert(1,AB)
			ii=ii+1
		if ((j/len(B[0]))*100)>=(k+5):
			k=k+5
			print('{}'.format(k)+'%')
		elif ((j/len(B[0]))*100)>=99:
			print('{}'.format(i/len(B[0])*100)+'%')
	t1_end=process_time()
	print('{}'.format(t1_end-t1_start)+' seconds')