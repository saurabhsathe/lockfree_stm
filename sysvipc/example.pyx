cdef extern from "math.h":
    cpdef double sqrt(int x)

cdef extern from "<sys/shm.h>":
    cpdef int shmget(int key, int size, int shmflg)
    cpdef shmat(int shmid, int addr, int shmflg)
    cpdef void memset(str content, int c, size_t n)

    

cpdef void myfun():
    print(sqrt(4))
        
    

