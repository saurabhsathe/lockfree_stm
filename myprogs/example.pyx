cdef extern from "math.h":
    cpdef double sqrt(int x)

cdef extern from "<sys/shm.h>":
    cpdef int shmget(object key, object size, int shmflg)
    

cpdef void myfun():
    print(sqrt(4))
        
    

