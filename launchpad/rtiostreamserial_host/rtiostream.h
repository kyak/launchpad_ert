#ifndef RTIOSTREAM_H
#define RTIOSTREAM_H

#include <stddef.h>

#define RTIOSTREAM_ERROR (-1)
#define RTIOSTREAM_NO_ERROR (0)

int rtIOStreamOpen(
    int    argc,
    void * argv[]
);

int rtIOStreamSend(
    int          streamID,
    const void * src, 
    size_t       size,
    size_t     * sizeSent
    );

int rtIOStreamRecv(
    int      streamID,
    void   * dst, 
    size_t   size,
    size_t * sizeRecvd
    );

int rtIOStreamClose(
    int streamID
    );

int	open_port(char * fullPortName, int baud);

#endif /* #ifndef RTIOSTREAM_H */
