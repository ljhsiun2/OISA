#ifndef __DEFS_HEADER__
#define __DEFS_HEADER__


//#define DEBUG

#ifdef DEBUG
#define dassert(x)      assert(x)
#define dprintf(x, ...) printf(x, ##__VA_ARGS__)
#else
#define dassert(x)
#define dprintf(x, ...)
#endif





#endif
