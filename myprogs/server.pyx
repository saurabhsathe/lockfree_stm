import time
def main():
    cdef extern from "sys/types.h":
        cdef extern from "sys/ipc.h":
            cdef extern from "sys/shm.h":
                cdef extern from "stdio.h":
                    cdef extern from "string.h":
                        cdef extern from "stdlib.h":
                            cdef extern from "unistd.h":
                                cdef extern from "defs.h":
                                    print("I am in the data segment")
                                    cdef int shmid=shmget(APP_SHM_KEY,APP_SHM_SIZE,IPC_CREAT | IPC_EXCL | 0666)
                                    if shmid<0:
                                        print("shmget")
                                        return
                                    cdef AppData *shm = (AppData*)shmat(shmid,NULL,0)
                                    if shm==(AppData *)-1:
                                        print("shmat")
                                        return
                                    shm->version=0
                                    shm->shutdown=false
                                    shm->ack=0
                                    memset(shm->payload,0,APP_PAYLOAD_SIZE)
                                    char *s = shm->payload
                                    for i in range(1,27):
                                        *s+=i
                                        shm->version+=1
                                        time.sleep(2)
                                    shm->shutdown=true
                                    while (shm->ack!='*'):
                                        print("waiting for client")
                                        time.sleep(1)
                                    shmdt(shm)
                                    shmctl(shmid,IPC_RMID,NULL)
                                    return
                                    

main()


                                        