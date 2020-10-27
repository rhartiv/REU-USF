##  Creating a quantum AND gate

def AND(i=0):
	if i==1:
		ANDt1=Id[1].tensor_product(Id[1].tensor_product(H[1].tensor_product(Id[1])))
		return ANDt1
	elif i==2:
		ANDt2=CNOT(2,0,4)*CNOT(1,3,4)*AND(1)
		return ANDt2
	elif i==3:
		ANDt3=CNOT(0,3,4)*CNOT(2,1,4)*AND(2)
		return ANDt3
	elif i==4:
		ANDt4=(conjugate(T[1]).transpose()).tensor_product((conjugate(T[1]).transpose()).tensor_product(T[1].tensor_product(T[1])))*AND(3)
		return ANDt4
	elif i==5:
		ANDt5=CNOT(2,1,4)*CNOT(0,3,4)*AND(4)
		return ANDt5	
	elif i==6:
		ANDt6=CNOT(1,3,4)*CNOT(2,0,4)*AND(5)
		return ANDt6	
	elif i==7:
		ANDt7=Id[1].tensor_product(Id[1].tensor_product(H[1].tensor_product(Id[1])))*AND(6)
		return ANDt7		
	else:
		ANDf=Id[1].tensor_product(Id[1].tensor_product(S[1].tensor_product(Id[1])))*AND(7)
		return ANDf


##  Creating the quantum AND-adjoint gate

def aAND(m=1,i=0):
	if m!=0:
		if i==1:
			aANDt1=Id[1].tensor_product(Id[1].tensor_product(H[1]))
			return aANDt1
		elif i==2:
			aANDt2=S[1].tensor_product(S[1].tensor_product(X))*aAND(1,1)
			return aANDt2
		elif i==3:
			aANDt3=CNOT(0,1,3)*aAND(1,2)
			return aANDt3
		elif i==4:
			aANDt4=Id[1].tensor_product((conjugate(S[1]).transpose()).tensor_product(H[1]))*aAND(1,3)
			return aANDt4
		else:
			aANDf=CNOT(0,1,3)*aAND(1,4)
			return aANDf
	else:
		return aAND(1,1)