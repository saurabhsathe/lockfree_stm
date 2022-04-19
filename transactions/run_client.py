from example_client import client
import time
t1=time.time()
client()
t2=time.time()
print("here is the execution time",t2-t1)