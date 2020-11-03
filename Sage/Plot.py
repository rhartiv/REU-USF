import matplotlib.pyplot as plt

Depth=[1,2,3,4]

t1=[0.44,5.2,6.1,6.5]
m1=[0.156,0.213,0.219,0.220]
t2=[0.5,12.7,22.8,74.9]
m2=[0.156,0.214,0.235,0.301]
t3=[0.2,32.8,459.8,1146.2]
m3=[0.157,0.248,0.624,1.363]
t4=[2.2,186.4,1472.2]
m4=[0.157,0.330,1.074]

plt.plot(Depth, m1, label="Single Qubit")
plt.plot(Depth,m2, label="Two Qubits")
plt.plot(Depth, m3, label="Three Qubits")
plt.plot([1,2,3], m4, label="Four Qubits")
plt.legend()
plt.xlabel("Gate Length")
plt.ylabel("Memory (GB)")
plt.show()

plt.plot(Depth, t1, label="Single Qubit")
plt.plot(Depth,t2, label="Two Qubits")
plt.plot(Depth, t3, label="Three Qubits")
plt.plot([1,2,3], t4, label="Four Qubits")
plt.legend()
plt.xlabel("Gate Length")
plt.ylabel("Time (s)")
plt.show()