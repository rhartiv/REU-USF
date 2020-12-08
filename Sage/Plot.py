import matplotlib.pyplot as plt

Depth=[1,2,3,4]


##  Original tests

Time1=[[0.44,5.2,6.1,6.5]]
Mem1=[[0.156,0.213,0.219,0.220]]
Time2=[[0.5,12.7,22.8,74.9]]
Mem2=[[0.156,0.214,0.235,0.301]]
Time3=[[0.2,32.8,459.8,1146.2]]
Mem3=[[0.157,0.248,0.624,1.663]]
Time4=[[2.2,186.4]]
Mem4=[[0.157,0.330]]

## Hashing using the matrix column as key and circuit-string as value, to generate matrices

Time1.append([1.8,10.3,15.5,33.7])
Mem1.append([0.156,0.212,0.216,0.216])
Time2.append([2.3,23.9,77.8,640.4])
Mem2.append([0.156,0.214,0.234,0.293])
Time3.append([2.9,48.7,1118.3])
Mem3.append([0.157,0.245,0.562)
Time4.append([2.7,292.2])
Mem4.append([0.157,0.315])

## Using just strings to generate matrices, to better optimize memory

Time1.append([1.8,10.7,15.9,32.5])
Mem1.append([0.156,0.213,0.219,0.220])
Time2.append([2.4,24.7,77.3,643.8])
Mem2.append([0.156,0.214,0.233,0.290])
Time3.append([2.8,49.1,1123.7])
Mem3.append([0.157,0.243,0.571)
Time4.append([2.2,293.9,])
Mem4.append([0.157,0.313])

## Using CIRCE with previous method (memory optimized)

Time1.append([10.8,33.2,94.4,183.5])
Time2.append([10.6,83.6,221.9,1784.2])
Time3.append([10.9,143.5,4423.3,42634.1])
Time4.append([11.2,773.2])

## Using CIRCE with parallel re-combination

Time1.append([10.8,44.5,95.2,177.9])
Time2.append([10.4,84.2,211.6,1642.1])
Time3.append([10.9,138.4,3447.2,35118.1])
Time4.append([11.1,772.8])

plt.plot(Depth, m1, label="Single Qubit")
plt.plot(Depth,Mem2, label="Two Qubits")
plt.plot(Depth, Mem3, label="Three Qubits")
plt.plot([1,2,3], Mem4, label="Four Qubits")
plt.legend()
plt.xlabel("Gate Length")
plt.ylabel("Memory (GB)")
plt.show()

plt.plot(Depth, t1, label="Single Qubit")
plt.plot(Depth,Time2, label="Two Qubits")
plt.plot(Depth, Time3, label="Three Qubits")
plt.plot([1,2,3], Time4, label="Four Qubits")
plt.legend()
plt.xlabel("Gate Length")
plt.ylabel("Time (s)")
plt.show()