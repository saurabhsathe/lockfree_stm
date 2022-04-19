from example import server
import time
t1=time.time()
server()
t2=time.time()
print("here is the execution time",t2-t1)
