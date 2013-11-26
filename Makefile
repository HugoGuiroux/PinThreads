PREFIX=/usr/local
CFLAGS=-Wall -g -g -O2 -DPREFIX="\"${PREFIX}\"" -fPIC
LDFLAGS=

OBJECTS = pin.o 

.PHONY: all clean
all: makefile.dep pinthreads pin.so

makefile.dep: *.[Cch]
	for i in *.[Cc]; do gcc -MM "$${i}" ${CFLAGS}; done > $@
	
-include makefile.dep

pin.so: pin.o parse_args.o
	${CC} -shared -o pin.so pin.o parse_args.o -ldl -lpthread

pinthreads: pinthreads.o parse_args.o
	${CC} ${CFLAGS} -o pinthreads pinthreads.o parse_args.o


install:
	mkdir -p ${PREFIX}/lib/pinthreads/
	cp pin.so ${PREFIX}/lib/pinthreads/
	cp pinthreads ${PREFIX}/bin

clean:
	rm -f *.o *.so makefile.dep pinthreads
