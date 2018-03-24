# curve25519 Makefile version 20050915
# D. J. Bernstein
# Public domain.
CC = gcc -O2 -m32

PATHS = /home/ljhsiun2/projects/research/multi2sim/bin/benchmarks/primitives/path_oram/path_oram.c /home/ljhsiun2/projects/research/multi2sim/bin/benchmarks/primitives/scan_oram/scan_oram.c\
	 /home/ljhsiun2/projects/research/multi2sim/bin/benchmarks/primitives/lib/misc.c /home/ljhsiun2/projects/research/multi2sim/bin/benchmarks/primitives/lib/asm.c\
	 /home/ljhsiun2/projects/research/multi2sim/bin/benchmarks/primitives/sort/merge_sort.c /home/ljhsiun2/projects/research/multi2sim/bin/benchmarks/primitives/sort/bitonic_sort.c

EXE = curve25519-speed

# Test programs:

default: test-curve25519

speedreport: speedreport.do \
curve25519.h cpucycles.h \
curve25519-speed test-curve25519
	sh speedreport.do > speedreport

test-curve25519: test-curve25519.o curve25519.a
	$(CC) -o test-curve25519 test-curve25519.o curve25519.a

test-curve25519.o: test-curve25519.c \
curve25519_athlon.h \
curve25519.h
	$(CC) -c test-curve25519.c

curve25519-speed: curve25519-speed.o curve25519.a cpucycles.a
	$(CC) -o curve25519-speed curve25519-speed.o curve25519.a cpucycles.a

curve25519-speed.o: curve25519-speed.c \
curve25519_athlon.h \
curve25519.h
	$(CC) -c curve25519-speed.c

cpucycles.h: curve25519.impl \
cpucycles.h.do
	sh -e cpucycles.h.do > cpucycles.h.new
	mv cpucycles.h.new cpucycles.h

cpucycles.a: curve25519.impl \
cpucycles_athlon.h \
cpucycles_athlon.s \
cpucycles.a.do
	sh -e cpucycles.a.do $(CC) > cpucycles.a.new
	mv cpucycles.a.new cpucycles.a


# The curve25519 library:

curve25519: curve25519.a curve25519.h

curve25519.h: curve25519.impl \
curve25519.h.do
	sh -e curve25519.h.do > curve25519.h.new
	mv curve25519.h.new curve25519.h

curve25519.a: curve25519.impl \
curve25519.a.do \
curve25519_athlon.h \
curve25519_athlon.c \
curve25519_athlon_const.s \
curve25519_athlon_fromdouble.s \
curve25519_athlon_init.s \
curve25519_athlon_mainloop.s \
curve25519_athlon_mult.s \
curve25519_athlon_square.s \
curve25519_athlon_todouble.s
	sh -e curve25519.a.do $(CC) > curve25519.a.new
	mv curve25519.a.new curve25519.a

curve25519.impl: \
curve25519.impl.do \
x86cpuid.c \
curve25519.impl.check.c \
curve25519_athlon.h \
curve25519_athlon.c \
curve25519_athlon_const.s \
curve25519_athlon_fromdouble.s \
curve25519_athlon_init.s \
curve25519_athlon_mainloop.s \
curve25519_athlon_mult.s \
curve25519_athlon_square.s \
curve25519_athlon_todouble.s
	sh -e curve25519.impl.do $(CC) > curve25519.impl.new
	mv curve25519.impl.new curve25519.impl

debug: curve25519-speed.o curve25519.a cpucycles.a
	gcc -std=c99 $(EXE).c $(PATHS) curve25519-speed.o curve25519.a cpucycles.a -Wall -g -o $(EXE)

opt: curve25519-speed.o curve25519.a cpucycles.a
	gcc -std=c99 $(EXE).c $(PATHS) curve25519-speed.o curve25519.a cpucycles.a -Wall -O3 -o $(EXE)

sim: curve25519-speed.o curve25519.a cpucycles.a
	$(CC) -o curve25519-speed curve25519-speed.o curve25519.a cpucycles.a

sim_opt: curve25519-speed.o curve25519.a cpucycles.a
	gcc -std=c99 $(PATHS) curve25519-speed.o curve25519.a cpucycles.a -Wall -D M2S -m32 -O3 -o $(EXE)

all_static: curve25519-speed.o curve25519.a cpucycles.a
	gcc -std=c99 $(EXE).c $(PATHS) curve25519-speed.o curve25519.a cpucycles.a -Wall -static -o $(EXE)

opt_static: curve25519-speed.o curve25519.a cpucycles.a
	gcc -std=c99 $(EXE).c $(PATHS) curve25519-speed.o curve25519.a cpucycles.a -Wall -static -O3 -o $(EXE)

sim_static: curve25519-speed.o curve25519.a cpucycles.a
	gcc -std=c99 $(EXE).c $(PATHS) curve25519-speed.o curve25519.a cpucycles.a -Wall -D M2S -static -m32 -o $(EXE)

sim_opt_static: curve25519-speed.o curve25519.a cpucycles.a
	gcc -std=c99 $(EXE).c $(PATHS) curve25519-speed.o curve25519.a cpucycles.a -Wall -D M2S -static -m32 -O3 -o $(EXE)
