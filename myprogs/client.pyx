import time
""""
def main():
    cdef extern from "<sys/types.h>":
        cdef extern from "<sys/ipc.h>":
            cdef extern from "<sys/shm.h>":
                cdef extern from "<stdio.h>":
                    cdef extern from "<stdlib.h>":
                        cdef extern from "<unistd.h>":
                            cdef extern from "<stdbool.h>":
                                cdef extern from "<defs.h>":
                                    #cdef int shmid 
                                    int shmid=shmget(APP_SHM_KEY,APP_SHM_SIZE)
                                    AppData *shm=shmat(shmid,None,0)
                                    
                                    int lastVersion = -1;
                                    do{
                                        if ( lastVersion != shm->version ) {
                                        lastVersion = shm->version;
                                        printf("--> %02d: %s\n", shm->version, shm->payload);
                                        }

                                        // simulate processing delay
                                        sleep(1);
                                    } while( !shm->shutdown )
main()
""""
