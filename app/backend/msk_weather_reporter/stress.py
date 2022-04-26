#!/usr/bin/python3
from multiprocessing import Pool
import psutil
import time
def f(x):
    set_time = 1
    timeout = time.time() + 60*float(set_time)  # X minutes from now
    while True:
        if time.time() > timeout:
            break
if __name__ == '__main__':
    processes = psutil.cpu_count()
    pool = Pool(processes)
    pool.map(f, range(processes))