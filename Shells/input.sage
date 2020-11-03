## Input file
import time
from concurrent.futures import ThreadPoolExecutor

import resource

from time import sleep

class MemoryMonitor:
    def __init__(self):
        self.keep_measuring = True

    def measure_usage(self):
        max_usage = 0
        while self.keep_measuring:
            max_usage = max(
                max_usage,
                resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
            )
            sleep(0.1)

        return max_usage/1000000000

load('~/Documents/Research/2020/QCP/Sage/SQG.sage')
load('~/Documents/Research/2020/QCP/Sage/MitMs.sage')
load('~/Documents/Research/2020/QCP/Sage/AND.sage')

start=time()
with ThreadPoolExecutor() as executor:
    monitor = MemoryMonitor()
    mem_thread = executor.submit(monitor.measure_usage)
    try:
        fn_thread = executor.submit(MitM,X0[1],0,4)
        result = fn_thread.result()
    finally:
        monitor.keep_measuring = False
        max_usage = mem_thread.result()
end=time()
elapsedtime=(end-start)
print(elapsedtime, float(max_usage))