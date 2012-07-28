#include "rtiostream.h"

/* Initialize Serial */
int rtIOStreamOpen(int argc, void *argv[])
{
    return RTIOSTREAM_NO_ERROR;
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
    return RTIOSTREAM_NO_ERROR;
}

/* Write data to serial */
int rtIOStreamSend(
    int          streamID,
    const void * src,
    size_t       size,
    size_t     * sizeSent)
{
    return RTIOSTREAM_NO_ERROR;
}

int rtIOStreamClose(int streamID)
{
    return RTIOSTREAM_NO_ERROR;
}