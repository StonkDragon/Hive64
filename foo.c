#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char const *argv[]) {
    FILE* fp = fopen("exception.rcx", "rb");
    if (fp == NULL) {
        printf("Error: cannot open file\n");
        return 1;
    }

    fseek(fp, 0, SEEK_END);
    long fsize = ftell(fp);
    fseek(fp, 0, SEEK_SET);

    char buffer[fsize + 1];
    fread(buffer, fsize, 1, fp);
    fclose(fp);

    for (int i = 0; i < fsize; i++) {
        printf("0x%02hhx", buffer[i]);
        if (i != fsize - 1) printf(", ");
        if (i % 8 == 7) printf("\n");
    }
    return 0;
}
