CXX = c++
LD = c++

FILES = primitives/path_oram/oram.o primitives/lib/misc.o primitives/sort/bitonic_sort.o

CXXFLAGS = -std=c++11 

all : dijkstras odijks prims oprims

dijkstras :
	$(LD) $(CXXFLAGS) dijkstras.cpp -o dijkstras

odijks : 
	$(LD) $(CXXFLAGS) primitives/lib/misc.c primitives/sort/bitonic_sort.c primitives/path_oram/oram.c odijks.cpp -o odijks

prims :
	$(LD) $(CXXFLAGS) prims.cpp -o prims

oprims :
	$(LD) $(CXXFLAGS) primitives/lib/misc.c primitives/sort/bitonic_sort.c primitives/path_oram/oram.c oprims.cpp -o oprims

clean :
	rm all

