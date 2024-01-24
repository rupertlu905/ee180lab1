#include <stdio.h>
#include <stdlib.h>

#define NUM_ELEMS 5000

int main(void) {
    FILE *fptr = fopen("random_input.txt", "w");
    if (fptr == NULL)
    {
        printf("ERROR Creating File!");
        exit(1);
    }
    for (int i = 0; i < NUM_ELEMS; ++i) {
        if (i == 0) {
            fprintf(fptr, "%d\n", NUM_ELEMS);
        }
        fprintf(fptr, "%lu\n", rand() % 4000000000);
    }
}