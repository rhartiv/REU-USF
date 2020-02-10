# Creating the quantum AND gate
Id=matrix.identity(2)
ANDt1=Id.tensor_product(Id.tensor_product(H.tensor_product(Id)))
ANDt2=CNOT(0,3,4)*CNOT(2,1,4)*CNOT(2,0,4)*CNOT(1,3,4)*ANDt1
ANDt3=(conjugate(T).transpose()).tensor_product((conjugate(T).transpose()).tensor_product(T.tensor_product(T)))*ANDt2
ANDt4=CNOT(1,3,4)*CNOT(2,0,4)*CNOT(2,1,4)*CNOT(0,3,4)*ANDt3
ANDt5=Id.tensor_product(Id.tensor_product(H.tensor_product(Id)))*ANDt4
AND=Id.tensor_product(Id.tensor_product(S.tensor_product(Id)))*ANDt5

# Creating the quantum AND-adjoint gate
