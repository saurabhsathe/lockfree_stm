#include <stdbool.h>

#define APP_PAYLOAD_SIZE 270

// our key (name) to the sharedmemory
#define APP_SHM_KEY 5000

// shared data
struct SharedMemoryDataStruct {
  int version;
  bool shutdown;
  char payload[APP_PAYLOAD_SIZE];
  char ack;
};

typedef struct SharedMemoryDataStruct AppData;

// size of shared memory
#define APP_SHM_SIZE (size_t)sizeof(AppData)
