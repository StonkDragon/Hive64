#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <errno.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char const *argv[]) {
    // create new memory mapping at 0xFFFFFFFF
    FILE* tmp = tmpfile();
    int fd = fileno(tmp);

    void* addr = mmap((void*)0x100000000, 16384, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_FIXED, fd, 0);
    printf("addr: %p\n", addr);
    printf("errno: %s\n", strerror(errno));
    
    uint32_t* data = (uint32_t*)addr;

    *data = 0x12345678;
}
