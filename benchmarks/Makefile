PATHS = /home/ljhsiun2/projects/research/multi2sim/bin/benchmarks/primitives/path_oram/path_oram.c /home/ljhsiun2/projects/research/multi2sim/bin/benchmarks/primitives/scan_oram/scan_oram.c\
	 /home/ljhsiun2/projects/research/multi2sim/bin/benchmarks/primitives/lib/misc.c /home/ljhsiun2/projects/research/multi2sim/bin/benchmarks/primitives/lib/asm.c\
	 /home/ljhsiun2/projects/research/multi2sim/bin/benchmarks/primitives/sort/merge_sort.c /home/ljhsiun2/projects/research/multi2sim/bin/benchmarks/primitives/sort/bitonic_sort.c

EXE = ofind_max

all:
	gcc -std=c99 $(EXE).c $(PATHS) -Wall -o $(EXE)

benchmarks:
	gcc -std=c99 $(PATHS) ofind_max.c -m32 -o ofind_max &&\
	gcc -std=c99 find_max.c -m32 -o find_max &&\
	gcc -std=c99 binary_search.c -m32 -o binary_search &&\
	gcc -std=c99 FC.c -m32 -o FC &&\
	gcc -std=c99 $(PATHS) ofind_max.c -m32 -o ofind_max &&\
	gcc -std=c99 $(PATHS) okmeans.c -m32 -o okmeans &&\
	gcc -std=c99 $(PATHS) obinary_search.c -m32 -o obinary_search &&\
	gcc -std=c99 $(PATHS) oblivFC.c -m32 -o oblivFC &&\
	gcc -std=c99 $(PATHS) pagerank2.c -m32 -o pagerank &&\
	gcc -std=c99 $(PATHS) opagerank.c -m32 -o opagerank




debug:
	gcc -std=c99 $(EXE).c $(PATHS) -Wall -g -o $(EXE)

opt:
	gcc -std=c99 $(EXE).c $(PATHS) -Wall -O3 -o $(EXE)

sim:
	gcc -std=c99 $(EXE).c $(PATHS) -Wall -D M2S -m32 -o $(EXE)

sim_opt:
	gcc -std=c99 $(EXE).c $(PATHS) -Wall -D M2S -m32 -O3 -o $(EXE)


all_static:
	gcc -std=c99 $(EXE).c $(PATHS) -Wall -static -o $(EXE)

opt_static:
	gcc -std=c99 $(EXE).c $(PATHS) -Wall -static -O3 -o $(EXE)

sim_static:
	gcc -std=c99 $(EXE).c $(PATHS) -Wall -D M2S -static -m32 -o $(EXE)

sim_opt_static:
	gcc -std=c99 $(EXE).c $(PATHS) -Wall -D M2S -static -m32 -O3 -o $(EXE)
