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
        char payload[256]
        char ack
        int lock_required
        int account_balance
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
    trans=["add","sub"]
    trans_values=[10,15]
    lock_requirements=[0,1]
    cdef int done=0
    cdef int current=0
    while done!=2:
        prev=0
        
        if shm[0].version!= current:
            while shm[0].lock_required==1:
                print("process 2 : wwaiting for other process to complete its transaction")
                sleep(1)
            
        print("process 2 : starting new transaction",trans[done])
        shm[0].version+=1
        shm[0].lock_required=lock_requirements[done]
        current=shm[0].version
        sleep(2)
        print("data version is ",shm[0].version)
        if trans[done]=="add":
            shm[0].account_balance=shm[0].account_balance*(1+trans_values[done]//100)
            sleep(2)
        elif trans[done]=="sub":
            shm[0].account_balance=shm[0].account_balance*(1-trans_values[done]//100)
            sleep(1)
        print("transaction complete from process 2 ")
        shm[0].lock_required=0
        done+=1
        print(shm[0].account_balance)
        sleep(2)
        
    print(shm[0].account_balance)
    

    

    sleep(2);
    shmdt(shm);
    shmctl(shmid, IPC_RMID, NULL);
    print("client shutting down\n");
    quit()
