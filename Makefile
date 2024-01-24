default:
	gcc -Wall -std=gnu99 -O3 -o radixsort radixsort.c
	gcc -Wall -std=gnu99 -O3 -o generate_random generate_random.c

clean:
	rm -f radixsort
	rm -f generate_random
