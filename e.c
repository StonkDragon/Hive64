#include <stdio.h>

int main(int argc, char const *argv[])
{
    volatile int x = 1;
    volatile int y = 0;

    volatile int z = x / y;
    if (0 - 1 ) {
        printf("z = %d\n", z);
    }
    return 0;
}
