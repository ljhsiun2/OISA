all:
	gcc -std=c99 ofind_max.c ../multi2sim/bin/benchmarks/primitives/path_oram/path_oram.c ../multi2sim/bin/benchmarks/primitives/scan_oram/scan_oram.c\
	 ../multi2sim/bin/benchmarks/primitives/lib/misc.c ../multi2sim/bin/benchmarks/primitives/lib/asm.c ../multi2sim/bin/benchmarks/primitives/sort/merge_sort.c\
	 ../multi2sim/bin/benchmarks/primitives/sort/bitonic_sort.c -Wall -o ofind_max

benchmarks:
	gcc -std=c99 ../multi2sim/bin/benchmarks/primitives/path_oram/path_oram.c ../multi2sim/bin/benchmarks/primitives/scan_oram/scan_oram.c\
	 ../multi2sim/bin/benchmarks/primitives/lib/misc.c ../multi2sim/bin/benchmarks/primitives/lib/asm.c\
	 ../multi2sim/bin/benchmarks/primitives/sort/merge_sort.c ../multi2sim/bin/benchmarks/primitives/sort/bitonic_sort.c ofind_max.c -m32 -o ofind_max \
	 && gcc -std=c99 ../multi2sim/bin/benchmarks/primitives/path_oram/path_oram.c ../multi2sim/bin/benchmarks/primitives/scan_oram/scan_oram.c\
	 ../multi2sim/bin/benchmarks/primitives/lib/misc.c ../multi2sim/bin/benchmarks/primitives/lib/asm.c\
	 ../multi2sim/bin/benchmarks/primitives/sort/merge_sort.c ../multi2sim/bin/benchmarks/primitives/sort/bitonic_sort.c binary_search.c -m32 -o binary_search\
	 && gcc -std=c99 ../multi2sim/bin/benchmarks/primitives/path_oram/path_oram.c ../multi2sim/bin/benchmarks/primitives/scan_oram/scan_oram.c\
	 ../multi2sim/bin/benchmarks/primitives/lib/misc.c ../multi2sim/bin/benchmarks/primitives/lib/asm.c\
	 ../multi2sim/bin/benchmarks/primitives/sort/merge_sort.c ../multi2sim/bin/benchmarks/primitives/sort/bitonic_sort.c pagerank2.c -m32 -o pagerank

debug:
	gcc -std=c99 ofind_max.c ../multi2sim/bin/benchmarks/primitives/path_oram/path_oram.c ../multi2sim/bin/benchmarks/primitives/scan_oram/scan_oram.c\
	 ../multi2sim/bin/benchmarks/primitives/lib/misc.c ../multi2sim/bin/benchmarks/primitives/lib/asm.c\
	 ../multi2sim/bin/benchmarks/primitives/sort/merge_sort.c ../multi2sim/bin/benchmarks/primitives/sort/bitonic_sort.c -Wall -g -o path_oram

opt:
	gcc -std=c99 ofind_max.c ../multi2sim/bin/benchmarks/primitives/path_oram/path_oram.c ../multi2sim/bin/benchmarks/primitives/scan_oram/scan_oram.c\
	 ../multi2sim/bin/benchmarks/primitives/lib/misc.c ../multi2sim/bin/benchmarks/primitives/lib/asm.c\
	 ../multi2sim/bin/benchmarks/primitives/sort/merge_sort.c ../multi2sim/bin/benchmarks/primitives/sort/bitonic_sort.c -Wall -O3 -o path_oram

sim:
	gcc -std=c99 ofind_max.c ../multi2sim/bin/benchmarks/primitives/path_oram/path_oram.c ../multi2sim/bin/benchmarks/primitives/scan_oram/scan_oram.c\
	 ../multi2sim/bin/benchmarks/primitives/lib/misc.c ../multi2sim/bin/benchmarks/primitives/lib/asm.c\
	 ../multi2sim/bin/benchmarks/primitives/sort/merge_sort.c ../multi2sim/bin/benchmarks/primitives/sort/bitonic_sort.c -Wall -D M2S -m32 -o path_oram

sim_opt:
	gcc -std=c99 ofind_max.c ../multi2sim/bin/benchmarks/primitives/path_oram/path_oram.c ../multi2sim/bin/benchmarks/primitives/scan_oram/scan_oram.c\
	 ../multi2sim/bin/benchmarks/primitives/lib/misc.c ../multi2sim/bin/benchmarks/primitives/lib/asm.c\
	 ../multi2sim/bin/benchmarks/primitives/sort/merge_sort.c ../multi2sim/bin/benchmarks/primitives/sort/bitonic_sort.c -Wall -D M2S -m32 -O3 -o path_oram


all_static:
	gcc -std=c99 ofind_max.c ../multi2sim/bin/benchmarks/primitives/path_oram/path_oram.c ../multi2sim/bin/benchmarks/primitives/scan_oram/scan_oram.c\
	 ../multi2sim/bin/benchmarks/primitives/lib/misc.c ../multi2sim/bin/benchmarks/primitives/lib/asm.c\
	 ../multi2sim/bin/benchmarks/primitives/sort/merge_sort.c ../multi2sim/bin/benchmarks/primitives/sort/bitonic_sort.c -Wall -static -o path_oram

opt_static:
	gcc -std=c99 ofind_max.c ../multi2sim/bin/benchmarks/primitives/path_oram/path_oram.c ../multi2sim/bin/benchmarks/primitives/scan_oram/scan_oram.c\
	 ../multi2sim/bin/benchmarks/primitives/lib/misc.c ../multi2sim/bin/benchmarks/primitives/lib/asm.c\
	 ../multi2sim/bin/benchmarks/primitives/sort/merge_sort.c ../multi2sim/bin/benchmarks/primitives/sort/bitonic_sort.c -Wall -static -O3 -o path_oram

sim_static:
	gcc -std=c99 ofind_max.c ../multi2sim/bin/benchmarks/primitives/path_oram/path_oram.c ../multi2sim/bin/benchmarks/primitives/scan_oram/scan_oram.c\
	 ../multi2sim/bin/benchmarks/primitives/lib/misc.c ../multi2sim/bin/benchmarks/primitives/lib/asm.c\
	 ../multi2sim/bin/benchmarks/primitives/sort/merge_sort.c ../multi2sim/bin/benchmarks/primitives/sort/bitonic_sort.c -Wall -D M2S -static -m32 -o path_oram

sim_opt_static:
	gcc -std=c99 ofind_max.c ../multi2sim/bin/benchmarks/primitives/path_oram/path_oram.c ../multi2sim/bin/benchmarks/primitives/scan_oram/scan_oram.c\
	 ../multi2sim/bin/benchmarks/primitives/lib/misc.c ../multi2sim/bin/benchmarks/primitives/lib/asm.c\
	 ../multi2sim/bin/benchmarks/primitives/sort/merge_sort.c ../multi2sim/bin/benchmarks/primitives/sort/bitonic_sort.c -Wall -D M2S -static -m32 -O3 -o path_oram
