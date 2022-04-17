# python3 example using cython

import example
import time

# simple python example
s = time.time()
r = example.add(2,3)
e = time.time()
print("r is {0}, ({1:.8f} sec)".format(r,(e-s)))

