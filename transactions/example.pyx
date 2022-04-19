import time
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
    int APP_SHM_KEY=5002
    cdef struct SharedMemoryDataStruct:
        int version
        int shutdown
        int account_balance
        char payload[256]
        char ack
        int lock_required
    ctypedef SharedMemoryDataStruct AppData
    int APP_SHM_SIZE
    
cpdef void server():
    t1=time.time()
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
    shm[0].account_balance=100
    shm[0].lock_required=0
    memset(shm[0].payload,0,APP_PAYLOAD_SIZE)
    cdef char *s =shm[0].payload



    print("initial account balance  is 100$")
    trans=["add","sub"]
    trans_values=[100,20]
    lock_requirements=[1,0]
    cdef int done=0
    cdef int current=0
    cdef int bal=shm[0].account_balance
    
    while done!=2:
        prev=0
        
        if shm[0].version!= current:
            while shm[0].lock_required==1:
                print("process 1 : wwaiting for other process to complete its transaction")
                sleep(1)
            
        print("process 1 : starting new transaction",trans[done])
        shm[0].lock_required=lock_requirements[done]
        current=shm[0].version
        bal=shm[0].account_balance
        print("data version is ",shm[0].version)
        if trans[done]=="add":
            bal+=trans_values[done]
            sleep(2)
        elif trans[done]=="sub":
            bal-=trans_values[done]
            sleep(1)
        if shm[0].version!=current:
            current=shm[0].version
            continue
        print("transaction complete from process 1 ")
        shm[0].account_balance=bal
        shm[0].version+=1
        shm[0].lock_required=0
        done+=1
        print(shm[0].account_balance)
        sleep(2)
        
    print(shm[0].account_balance)
            

    
    
    
    
    shmdt(shm)
    shmctl(shmid,IPC_RMID,NULL)
    t2=time.time()
    print("here is the execution time",t2-t1)
    quit()
