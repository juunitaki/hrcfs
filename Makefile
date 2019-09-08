CC=gcc
LDLIBS=-lfuse -lcurl
CFLAGS=-D_FILE_OFFSET_BITS=64 -Wall

all: hrcfs

indent:
	indent -orig -ts4 hrcfs.c

ctags:
	ctags hrcfs.c

clean:
	rm -f hrcfs tags hrcfs.c~
