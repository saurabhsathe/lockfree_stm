import sysv_ipc
import sys
#rds replicate
# data will be 2,4,6,8,10. cytthon wali side will multiply it by 2 and java side will multiply same values by 5

#ho will we measure?
"""
1) execution time of python and java process
2) execution time of python and python
3) execution time of python and c++
4) execution time of java and c++
-----
number of threads kinva processing parallely working on it like 2 python and 2 java
---

"""

import time
import sys
mylist=[9,8,7,6,5,4,3,2,1]
memory = sysv_ipc.SharedMemory(3000,sysv_ipc.IPC_CREX,size=sys.getsizeof(mylist))

for i in range(0,10):
    memory.write(" serverside {}".format(i))
    time.sleep(2)
    x=memory.read()
    print(x)
    
#sysv_ipc.remove_shared_memory(3000)