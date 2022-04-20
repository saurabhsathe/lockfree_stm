cdef extern from "string.h":
    void memset(void *addr, int val, size_t len)
    void memcpy(void *trg, void *src, size_t len)

cdef extern from "sys/types.h":
    ctypedef int key_t

cdef extern from "sys/shm.h":

    ctypedef unsigned int shmatt_t

    cdef struct shmid_ds:
        shmatt_t shm_nattch

    int   shmget(key_t key, int size, int shmflg)
    void *shmat(int shmid, void *shmaddr, int shmflg)
    int   shmdt(void *shmaddr)
    int   shmctl(int shmid, int cmd, shmid_ds *buf) nogil


cdef extern from "sys/ipc.h":
    int IPC_STAT, IPC_RMID, IPC_CREAT, IPC_EXCL, IPC_PRIVATE


cdef extern from "unistd.h":
    unsigned int sleep(unsigned int seconds) nogil

cdef extern from "defs.h":
    int APP_PAYLOAD_SIZE=256
    int APP_SHM_KEY=5001
    cdef struct SharedMemoryDataStruct:
        int version
        int shutdown
        char payload[256]
        char ack
    ctypedef SharedMemoryDataStruct AppData
    int APP_SHM_SIZE
    
cpdef void server():
    print("size of app data segment: \n", APP_SHM_SIZE);
    cdef int shmid = shmget(APP_SHM_KEY, 100, IPC_CREAT| 0666)
    print(shmid)
    print("hello")
    if shmid < 0:
        print("server shmget")
        quit()
    cdef AppData *shm = <AppData*>shmat(shmid, NULL, 0)
    if (shm == <AppData *> -1):
        print("server shmat")
        quit()
    shm[0].version=0
    shm[0].shutdown=False
    shm[0].ack=0
    memset(shm[0].payload,0,APP_PAYLOAD_SIZE)
    cdef char *s =shm[0].payload

    for c in range(97,123):
        s[0]=c
        s+=1
        shm[0].version+=1
        sleep(2) 
    shm.shutdown=1
    while shm[0].ack!="*":
        print("waiting for the client process to finish")
        sleep(1)
    print("client shutdown acknowledgement received")
    shmdt(shm)
    shmctl(shmid,IPC_RMID,NULL)
    quit()
