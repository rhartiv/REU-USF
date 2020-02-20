##  Creating the quantum AND gate

def AND(i=0):
	if i==1:
		ANDt1=Id.tensor_product(Id.tensor_product(H.tensor_product(Id)))
		return ANDt1
	elif i==2:
		ANDt2=CNOT(2,0,4)*CNOT(1,3,4)*AND(1)
		return ANDt2
	elif i==3:
		ANDt3=CNOT(0,3,4)*CNOT(2,1,4)*AND(2)
		return ANDt3
	elif i==4:
		ANDt4=(conjugate(T).transpose()).tensor_product((conjugate(T).transpose()).tensor_product(T.tensor_product(T)))*AND(3)
		return ANDt4
	elif i==5:
		ANDt5=CNOT(2,1,4)*CNOT(0,3,4)*AND(4)
		return ANDt5	
	elif i==6:
		ANDt6=CNOT(1,3,4)*CNOT(2,0,4)*AND(5)
		return ANDt6	
	elif i==7:
		ANDt7=Id.tensor_product(Id.tensor_product(H.tensor_product(Id)))*AND(6)
		return ANDt7		
	else:
		ANDf=Id.tensor_product(Id.tensor_product(S.tensor_product(Id)))*AND(7)
		return ANDf


##  Creating the quantum AND-adjoint gate

def aAND(m=1,i=0):
	if m!=0:
		if i==1:
			aANDt1=Id.tensor_product(Id.tensor_product(H))
			return aANDt1
		elif i==2:
			aANDt2=S.tensor_product(S.tensor_product(X))*aAND(1,1)
			return aANDt2
		elif i==3:
			aANDt3=CNOT(0,1,3)*aAND(1,2)
			return aANDt3
		elif i==4:
			aANDt4=Id.tensor_product((conjugate(S).transpose()).tensor_product(H))*aAND(1,3)
			return aANDt4
		else:
			aANDf=CNOT(0,1,3)*aAND(1,4)
			return aANDf
	else:
		return aAND(1,1)