default:
	gcc -Wall -std=gnu99 -O3 -o radixsort radixsort.c

clean:
	rm -f radixsort
