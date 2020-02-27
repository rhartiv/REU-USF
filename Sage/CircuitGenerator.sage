## Generator of all length 3 circuits using common gates from the Gates.sage file,
## for an input of "n" qubits.

def Circuit3(n):
	l=len(GateTypes)
	Gates=[0]
	for i in range(l):
		Gates.append([GateTypes[i]])
	Gates.remove(0)
	GateLabel=['X','Y','Z','S','T','H','CNOT']
	Circuits={'Id': matrix.identity(2^n)}
	
	for i in range(l):
		for ii in range(n): 
			Gates[i].append(Gate(ii,n,Gates[i][0]))
			if Gates[i][0]==X:
				for iii in range(1,n):
					GatesDict['X{}'.format(ii)]=Gates[i][ii+1]
			elif Gates[i][0]==Y:
				for iii in range(1,n):
					GatesDict['Y{}'.format(ii)]=Gates[i][ii+1]
			elif Gates[i][0]==Z:
				for iii in range(1,n):
					GatesDict['Z{}'.format(ii)]=Gates[i][ii+1]
			elif Gates[i][0]==S:
				for iii in range(1,n):
					GatesDict['S{}'.format(ii)]=Gates[i][ii+1]
			elif Gates[i][0]==T:
				for iii in range(1,n):
					GatesDict['T{}'.format(ii)]=Gates[i][ii+1]
			elif Gates[i][0]==H:
				for iii in range(1,n):
					GatesDict['H{}'.format(ii)]=Gates[i][ii+1]
	for i in range(n):
		for j in range(n):
			if j!=i:
				GatesDict['CNOT{},{}'.format(i,j)]=CNOT(i,j,n)
	
	for i in range(l):
		for ii in range(n):
			if (GatesDict[GateLabel[i]+'{}'.format(ii)] in Circuits.values())!=true:
				Circuits[GateLabel[i]+'{}'.format(ii)]=GatesDict[GateLabel[i]+'{}'.format(ii)]
		for j in range(l):
			for ii in range(n):
				for jj in range(n):
					Circuits[GateLabel[i]+'{}'.format(ii)+','+GateLabel[j]+'{}'.format(jj)]=GatesDict[GateLabel[i]+'{}'.format(ii)]*GatesDict[GateLabel[j]+'{}'.format(jj)]
			for k in range(l):
				for ii in range(n):
					for jj in range(n):
						for kk in range(n):
							Circuits[GateLabel[i]+'{}'.format(ii)+','+GateLabel[j]+'{}'.format(jj)+','+GateLabel[k]+'{}'.format(kk)]=GatesDict[GateLabel[i]+'{}'.format(ii)]*GatesDict[GateLabel[j]+'{}'.format(jj)]*GatesDict[GateLabel[k]+'{}'.format(kk)]
	return Circuits


