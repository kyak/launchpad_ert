CC=gcc
CFLAGS+=-g
LDFLAGS+=

all:
	$(CC) -c -fPIC -Wall $(CFLAGS) rtiostreamserial_host.c
	$(CC) -shared -Wl,-soname,librtiostreamserial.so $(LDFLAGS) -o librtiostreamserial.so rtiostreamserial_host.o

clean:
	rm -f rtiostreamserial_host.o librtiostreamserial.so
