# Target Tool Specification Makefile (target_tools_unix.mk)

# Compiler command and options
CC = "$(MSPGCC)"
CFLAGS = -mmcu=msp430g2553

CFLAGS += $(OPTS)
CDEBUG = -g
CCOUTPUTFLAG = -o

CXX      =
CXXFLAGS =
CXXDEBUG =

# Linker command and options
LD      = $(CC)
LDFLAGS = -mmcu=msp430g2553
LDDEBUG = -g
LDOUTPUTFLAG = -o

# Archiver command and options
AR      = $(subst -gcc,-ar,$(CC))
ARFLAGS = -r

# Binary file format converter command and options
OBJCOPY      = 
OBJCOPYFLAGS = 

# Specify the output extension from compiler
OBJ_EXT = .o

# Specify extension from linker
PROGRAM_FILE_EXT = .out 

# Specify extension for final product at end of build
EXE_FILE_EXT     = $(PROGRAM_FILE_EXT)
