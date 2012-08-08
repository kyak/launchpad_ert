#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>  /* UNIX standard function definitions */
#include <fcntl.h>   /* File control definitions */
#include <errno.h>   /* Error number definitions */
#include <termios.h> /* POSIX terminal control definitions */
#include "rtiostream.h"

#include "mex.h"

/* Full port name length, e.g. /dev/ttyACM0 */
#define MAX_COM_LEN 20
#define COM_PORT_PREFIX "/dev/"	/* <- */
								/*  | */
#define MAX_COM_LEN_PREFIX 5	/* <- */
#define DEF_COM_NAME "/dev/ttyACM0"
#define DEF_COM_BAUD 2400

/* Initialize Serial */
int rtIOStreamOpen(int argc, void *argv[])
{
	int retVal = RTIOSTREAM_NO_ERROR;
	int count = 0;
	char fullPortName[MAX_COM_LEN] = "";
	int baud = 0;
	while(count < argc)
	{
		const char *option = (char *)argv[count];
		count++;
		if (option != NULL) {
			if ((strcmp(option, "-port") == 0) && (count != argc)) {
				const char *portName = (char *)argv[count];
				count++;
				if ((portName == NULL) || (strlen(portName) > MAX_COM_LEN-MAX_COM_LEN_PREFIX)) {
					printf("rtIOStreamOpen: Length of serial port name %s exceeds allowed limit of %d.\n",portName,MAX_COM_LEN-MAX_COM_LEN_PREFIX);
					retVal = RTIOSTREAM_ERROR;
					break;
				}
				strcat(fullPortName, COM_PORT_PREFIX);
				strcat(fullPortName, portName);
				argv[count-2] = NULL;
				argv[count-1] = NULL;
			} else if ((strcmp(option, "-baud") == 0) && (count != argc)) {
				const char *baudStr = (char *)argv[count];
				count++;
				baud = atoi(baudStr);
				argv[count-2] = NULL;
				argv[count-1] = NULL;
			} else {
			}
		}
	}
	if (retVal != RTIOSTREAM_ERROR) {
		if (strcmp(fullPortName,"") == 0) { /* no -port argument supplied */
			strcat(fullPortName, DEF_COM_NAME);
		}
		if (baud <= 0) { /* no -baud argument or bad value supplied */
			baud = DEF_COM_BAUD;
		}
		printf("rtIOStreamOpen: Opening serial port %s at baud %d...\n",fullPortName,baud);
		retVal = open_port(fullPortName, baud);
	}
	return retVal;
}

/* Read data from serial */
int rtIOStreamRecv(
    int      streamID, /* A handle to the stream that was returned by a previous call to rtIOStreamOpen. */
    void   * dst,      /* A pointer to the start of the buffer where received data must be copied. */
    size_t   size, /* Size of data to copy into the buffer. For byte-addressable architectures, */
                   /* size is measured in bytes. Some DSP architectures are not byte-addressable. */
                   /* In these cases, size is measured in number of WORDs, where sizeof(WORD) == 1. */
    size_t * sizeRecvd) /* The number of units of data received and copied into the buffer dst (zero if no data was copied). */
{
	/* TODO: catch errors */
	/* printf("rtIOStreamRecv: entering...\n"); */
	*sizeRecvd = read(streamID, dst, size);
	if (*sizeRecvd == -1)
		*sizeRecvd = 0;
    return RTIOSTREAM_NO_ERROR;
}

/* Write data to serial */
int rtIOStreamSend(
    int          streamID,
    const void * src,
    size_t       size,
    size_t     * sizeSent)
{
	/* TODO: catch errors */
	/* printf("rtIOStreamSend: entering...\n"); */
	*sizeSent = write(streamID, src, size);
    return RTIOSTREAM_NO_ERROR;
}

int rtIOStreamClose(int streamID)
{
	printf("rtIOStreamClose: Closing serial port at streamID %d...\n",streamID);
	close(streamID);
    return RTIOSTREAM_NO_ERROR;
}

/*
 * Returns the file descriptor on success or -1 on error.
 */

int	open_port(char * fullPortName, int baud)
{
	struct termios tty;
	memset (&tty, 0, sizeof tty);
	int fd; /* File descriptor for the port */

	fd = open(fullPortName, O_RDWR | O_NOCTTY | O_NDELAY);
	if (fd == -1)
	{
		printf("open_port: Unable to open %s\n", fullPortName);
		return -1;
	}
	else {
		int flags = fcntl(fd, F_GETFL, 0);
		fcntl(fd, F_SETFL, flags | O_NONBLOCK); /* Non-Blocking */
		//fcntl(fd, F_SETFL, 0); /* Blocking */
	}
	printf("open_port: Opened serial port %s\n", fullPortName);
	if (tcgetattr(fd, &tty) != 0)
	{
		printf("open_port: Error %d from tcgetattr", errno);
		return -1;
	}
	/* TODO: make this configurable, see
	 * http://git.savannah.gnu.org/gitweb/?p=coreutils.git;a=blob;f=src/stty.c
	 * for speed_t string_to_baud (const char *arg);
	 */
	/* cfsetspeed(&tty, B2400); */
	cfsetspeed(&tty, baud);
	tcsetattr(fd, TCSANOW, &tty);
	return (fd);
}