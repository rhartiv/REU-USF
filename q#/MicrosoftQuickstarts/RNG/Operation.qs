namespace Quantum {
	open Microsoft.Quantum.Intrinsic;
	
	operation QuantumRandomNumberGenerator() : Result {
		using(q = Qubit())	{ // Allocate a qubit.
			H(q);			  // Put the qubit to superposition. It now has a 50% chance of being 0 or 1.
			let r = M(q);	  // Measure the qubit value.
			Reset(q);
			return r;
		}
	}
	
}