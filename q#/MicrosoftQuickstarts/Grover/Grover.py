import qsharp
from Microsoft.Quantum.Samples.SimpleGrover import SearchForMarkedInput
from Microsoft.Quantum.Samples.SimpleGrover import NIterations


n_qubits = 15
result = [SearchForMarkedInput.simulate(nQubits=n_qubits),NIterations.simulate(nQubits=n_qubits)]
print(result)
