benchmarks:
	gcc -std=c99 ../benchmarks/primitives/lib/misc.c ../benchmarks/primitives/sort/bitonic_sort.c \
	 ../benchmarks/primitives/path_oram/oram.c ../benchmarks/primitives/sort/merge_sort.c find_max.c -m32 -o find_max \
	 && gcc -std=c99 ../benchmarks/primitives/lib/misc.c ../benchmarks/primitives/sort/bitonic_sort.c \
	../benchmarks/primitives/path_oram/oram.c ../benchmarks/primitives/sort/merge_sort.c binary_search.c -m32 -o binary_search

opt:
	gcc -std=c99 find_max.c ../benchmarks/primitives/path_oram/oram.c ../benchmarks/primitives/lib/misc.c \
	 ../benchmarks/primitives/sort/bitonic_sort.c ../benchmarks/primitives/sort/merge_sort.c -O3 -o find_max

sim:
	gcc -std=c99 find_max.c ../benchmarks/primitives/path_oram/oram.c ../benchmarks/primitives/lib/misc.c \
	 ../benchmarks/primitives/sort/bitonic_sort.c ../benchmarks/primitives/sort/merge_sort.c -m32 -o find_max

sim_opt:
	gcc -std=c99 find_max.c ../benchmarks/primitives/path_oram/oram.c ../benchmarks/primitives/lib/misc.c \
	 ../benchmarks/primitives/sort/bitonic_sort.c ../benchmarks/primitives/sort/merge_sort.c -m32 -O3 -o find_max

all_static:
	gcc -std=c99 find_max.c ../benchmarks/primitives/path_oram/oram.c ../benchmarks/primitives/lib/misc.c \
	 ../benchmarks/primitives/sort/bitonic_sort.c ../benchmarks/primitives/sort/merge_sort.c -static -o find_max

opt_static:
	gcc -std=c99 find_max.c ../benchmarks/primitives/path_oram/oram.c ../benchmarks/primitives/lib/misc.c \
	 ../benchmarks/primitives/sort/bitonic_sort.c ../benchmarks/primitives/sort/merge_sort.c -static -O3 -o find_max

sim_static:
	gcc -std=c99 find_max.c ../benchmarks/primitives/path_oram/oram.c ../benchmarks/primitives/lib/misc.c \
	 ../benchmarks/primitives/sort/bitonic_sort.c ../benchmarks/primitives/sort/merge_sort.c -static -m32 -o find_max

sim_opt_static:
	gcc -std=c99 find_max.c ../benchmarks/primitives/path_oram/oram.c ../benchmarks/primitives/lib/misc.c \
	 ../benchmarks/primitives/sort/bitonic_sort.c ../benchmarks/primitives/sort/merge_sort.c -static -m32 -O3 -o find_max