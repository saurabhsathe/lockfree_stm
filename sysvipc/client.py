import time
import sysv_ipc
memory = sysv_ipc.SharedMemory(5000)
for i in range(1,11):
    x=memory.read()
    time.sleep(1)
    print(x[0])
    

