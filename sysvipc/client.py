import time
import sysv_ipc
memory = sysv_ipc.SharedMemory(3000)
for i in range(1,6):
    memory.write(" client side {}".format(i))
    time.sleep(1)
    x=memory.read()
    print(x)
    

