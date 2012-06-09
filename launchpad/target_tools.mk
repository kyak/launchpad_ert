# Target Tool Specification Makefile (target_tools.mk)

# Compiler command and options
CC = "$(CompilerRoot)\bin\cl430"
CFLAGS = -vmsp --abi=eabi -g --include_path="$(CCSRoot)/ccs_base/msp430/include" \
         --include_path="$(CompilerRoot)/include" --define=__MSP430G2553__

CFLAGS += $(OPTS)
CDEBUG = -g
CCOUTPUTFLAG = --output_file=

CXX      =
CXXFLAGS =
CXXDEBUG =

# Linker command and options
LD      = "$(CC)"
LDFLAGS = -vmsp --abi=eabi -g --define=__MSP430G2553__ -z --stack_size=80 \
          -m"$(MODEL).map" --heap_size=80 -i"$(CCSRoot)/ccs_base/msp430/include" \
          -i"$(CompilerRoot)/lib" -i"$(CompilerRoot)/include" --reread_libs \
          --rom_model "$(CCSRoot)/ccs_base/msp430/include/lnk_msp430g2553.cmd"
LDDEBUG = -g
LDOUTPUTFLAG = --output_file=

# Archiver command and options
AR      = "$(CompilerRoot)\bin\ar430"
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