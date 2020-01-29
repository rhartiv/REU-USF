import qsharp

from Quantum import QuantumRandomNumberGenerator

max = 7
RNG = max + 1
while RNG > max:
	output_string = []
	for i in range(0,max.bit_length()):
		output_string.append(QuantumRandomNumberGenerator.simulate())
	RNG = int("".join(str(x) for x in output_string), 2)

print("The quantum randum number generated is " + str(RNG))