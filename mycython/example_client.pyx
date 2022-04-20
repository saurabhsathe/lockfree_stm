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
    
cpdef void client():
    print("size of app data segment: \n", APP_SHM_SIZE);
    cdef int shmid = shmget(APP_SHM_KEY, 100,0666);
    print("hello")
    if shmid < 0:
        print("client shmget")
        quit() 
    print("Reached here 1")
    cdef AppData *shm = <AppData*>shmat(shmid, NULL, 0)
    print("Reached here 2")
    if (shm == <AppData *> 0):
        print("client shmat")
        quit()
    print("Reached here 3")
    cdef int latest_version=-1
    while True:
        if latest_version!=shm[0].version:
            latest_version=shm[0].version
            print("latest version updated to",latest_version)
        sleep(1)
        if shm[0].shutdown==1:
            break
    shm[0].ack="*"

    sleep(2);
    shmdt(shm);
    shmctl(shmid, IPC_RMID, NULL);
    print("client shutting down\n");
    quit()
