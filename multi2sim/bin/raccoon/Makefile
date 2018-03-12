benchmarks:
	gcc -std=c99 ../benchmarks/primitives/lib/misc.c ../benchmarks/primitives/sort/bitonic_sort.c \
	 ../benchmarks/primitives/path_oram/oram.c find_max.c -m32 -o find_max\
	 && gcc -std=c99 ../benchmarks/primitives/lib/misc.c ../benchmarks/primitives/sort/bitonic_sort.c \
	../benchmarks/primitives/path_oram/oram.c binary_search.c -m32 -o binary_search

all_static:
	g++ main.c oram.c ../benchmarks/primitives/lib/misc.c ../benchmarks/primitives/sort/bitonic_sort.c \
	 -static -o oram

opt_static:
	g++ ../benchmarks/primitives/path_oram/main.c ../benchmarks/primitives/path_oram/oram.c \
	 ../benchmarks/primitives/lib/misc.c ../benchmarks/primitives/sort/bitonic_sort.c -static -O3 -o oram

sim_static:
	g++ ../benchmarks/primitives/path_oram/main.c ../benchmarks/primitives/path_oram/oram.c \
	../benchmarks/primitives/lib/misc.c ../benchmarks/primitives/sort/bitonic_sort.c -static -m32 -o oram

sim_opt_static:
	g++ ../benchmarks/primitives/path_oram/main.c ../benchmarks/primitives/path_oram/oram.c \
	 ../benchmarks/primitives/lib/misc.c ../benchmarks/primitives/sort/bitonic_sort.c -static -m32 -O3 -o oram