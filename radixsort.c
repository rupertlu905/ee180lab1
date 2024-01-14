/**********************************************************
* radixsort.c                                             *
*                                                         *
* This program sorts using a simple radix sort algorithm. *
* Written by Ian MacFarlane (ianpmac@stanford.edu)        *
**********************************************************/

#define RADIX 10

#include "stdio.h"
#include "stdlib.h"

void radsort(unsigned *array, unsigned n, unsigned exp);
unsigned find_exp(unsigned *array, unsigned n);
void copy_array(unsigned *dst, unsigned *src, unsigned n);

int main() {
    unsigned *array, i, array_size;

    printf("How many elements to be sorted? ");
    int tokens_read = scanf("%u", &array_size);
    if (tokens_read != 1) {
        printf("Could not read array size.\n");
        exit(1);
    }

    array = (unsigned *) malloc(sizeof(unsigned) * (array_size+1));

    for (i = 0; i < array_size; i++) {
        printf("Enter next element: ");
        tokens_read = scanf("%d", &(array[i]));
        if (tokens_read != 1) {
            printf("Could not read the next element.\n");
            exit(1);
        }
    }

    // radix sort call
    if (array_size > 0) {
        radsort(array, array_size, find_exp(array, array_size));
    }

    printf("The sorted list is:\n");
    for (i = 0; i < array_size; i++)
        printf("%d ", array[i]);
    printf("\n");
    free(array);
}

// main radix sort routine. Recursively sorts array
// by the log_RADIX(exp) digit into RADIX buckets,
// then calls itself on each bucketed subarray.
void radsort(unsigned *array, unsigned n, unsigned exp)
{
    // Base case: one element or out of digits means all entries are sorted
    if (n < 2 || exp == 0)
        return;

    // Recursive case: sort elements in sub-arrays by radix, and call radix sort
    unsigned **children = (unsigned **)malloc(sizeof(unsigned *) * RADIX);
    unsigned *children_len = (unsigned *)malloc(sizeof(unsigned) * RADIX);

    // Initialize bucket counts to zero
    for (int i = 0; i < RADIX; i++) {
        children_len[i] = 0;
    }

    // Assign array values to appropriate buckets
    for (int i = 0; i < n; i++) {
        unsigned sort_index = (array[i] / exp) % RADIX;
        if (children_len[sort_index] == 0)
            children[sort_index] = (unsigned *)malloc(sizeof(unsigned) * n);
        children[sort_index][children_len[sort_index]] = array[i];
        children_len[sort_index]++;
    }

    // Call radixsort on buckets and then concatenate
    int idx = 0;
    for (int i = 0; i < RADIX; i++) {
        if (children_len[i] != 0) {
            radsort(children[i], children_len[i], exp/RADIX);
        }
        // Concatenate bucket arrays by radix into main array
        copy_array(array+idx, children[i], children_len[i]);
        idx += children_len[i];
    }

    // Free allocated memory
    for (int i = 0; i < RADIX; i++) {
        if (children_len[i] != 0)
            free(children[i]);
    }
    free(children);
    free(children_len);
}

// C analogue to find_exp helper function in radixsort.s
unsigned find_exp(unsigned *array, unsigned n) {
    unsigned largest = array[0];
    for (int i = 0; i < n; i++) {
        if (largest <= array[i])
            largest = array[i];
    }
    unsigned exp = 1;
    while (largest >= RADIX) {
        largest = largest / RADIX;
        exp = exp * RADIX;
    }
    return exp;
}

// C analogue to arrcpy helper function in radixsort.s
void copy_array(unsigned *dst, unsigned *src, unsigned n) {
    int i;
    for (i = 0; i < n; i++)
        dst[i] = src[i];
}
