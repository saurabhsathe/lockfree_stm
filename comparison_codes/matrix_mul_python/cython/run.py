import multi
import cymulti
import time
time1=time.time()
multi.pymultiply()
time2=time.time()
print(time2-time1)
time3=time.time()
cymulti.multiply()
time4=time.time()
print(time4-time3)