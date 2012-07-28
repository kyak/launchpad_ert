CC=gcc
CFLAGS=

all:
	$(CC) -c -fPIC rtiostreamserial_host.c
	$(CC) -shared -Wl,-soname,librtiostreamserial.so.0 -o librtiostreamserial.so rtiostreamserial_host.o

clean:
	rm -f rtiostreamserial_host.o librtiostreamserial.so