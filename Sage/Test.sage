reset()

import random

@parallel(ncpus=8)
def r(l = 100,k = 100):
    return [str(random.randint(0,2**100)) for _ in range(l)]

L = r(2**20)
R = r(2**20)

import time

t0 = time.time()
print(str(random.randint(0,2**100)) in L)
t1 = time.time()

print(t1-t0)

print()
D = dict(zip(L,R))
t0 = time.time()
print(str(random.randint(0,2**100)) in D)
t1 = time.time()

print(t1-t0)