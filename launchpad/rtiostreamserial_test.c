#include <msp430.h>
#include "rtiostream.h"

void serial_simple_step(void)
{

#define MAX_PACKET_SIZE 50

    unsigned char data[MAX_PACKET_SIZE];
	//unsigned short data[MAX_PACKET_SIZE];

    static unsigned int packetSize=1;
    unsigned int i;

    if (packetSize <= MAX_PACKET_SIZE) {
        size_t sizeRecvd;
        unsigned int packetIdx=0;
        rtIOStreamRecv(0, data, (size_t) packetSize, &sizeRecvd);
        packetIdx=(unsigned int) sizeRecvd;
        while (packetIdx < packetSize) {
            rtIOStreamRecv(0, &data[packetIdx], (size_t) (packetSize-packetIdx), &sizeRecvd);
            packetIdx=packetIdx+(unsigned int) sizeRecvd;
        }
        for (i=0; i<packetSize; i++) {
            /* Expected return packet is received data + 1 */
            data[i]=data[i]+1;
        }
        {
            size_t tmp;
            rtIOStreamSend( 0, data, packetSize, &tmp);
        }
        packetSize++;
    }
}


int main(void)
{

  /* Initialize rtiostream channel */
  rtIOStreamOpen(0,NULL);

  while (1) {
      serial_simple_step();
  }

}
