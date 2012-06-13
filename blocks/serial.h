#ifndef __SERIAL_H
#define __SERIAL_H

void serial_init(void);
unsigned char serial_getc();
void serial_putc(unsigned char c);

#endif
