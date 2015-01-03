################################################################################
# File Name: 	makefile
################################################################################
# Desription: 	The main makefile used by the GNU Make.
# 
#
# Copyright (C) 2015 by Omid Manikhi. All rights reserved...
################################################################################


################################################################################
# Functions
################################################################################

# Recursive wildcard function
rwildcard = $(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

# enumerates files in the filesystem and returns their path relative to the project root
# $1 the directory relative to the project root
# $2 the pattern to match, e.g. *.cpp
target_files = $(patsubst $(SRC_DIR)/%,%,$(call rwildcard,$(SRC_DIR)/$1,$2))


################################################################################
# Directory Definitions
################################################################################

# by convention, all symbols referring to a directory end with a slash - this 
# allows directories to resolve to "" when equal to the working directory.
SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

# The project directory is the current directory where the makefile is placed.
PROJECT_DIR := $(SELF_DIR)

# Define the build path, this is where all of the dependancies and
# object files will be placed.
# Note: Currently set to <project>/build/obj directory and set relative to
# the dir which makefile is invoked.
BUILD_DIR = $(SELF_DIR)build/obj

# Path to the root of source files, in this case root of the project to
# include ../src and ../lib dirs.
# Note: Consider relocating source files in lib to src, or build a
#       separate library.
SRC_DIR = src

TARGET ?= firmware
TARGETDIR ?= $(SELF_DIR)bin/

# ensure defined
USRSRC += ""

CSRC += $(call target_files,$(USRSRC),*.c)
CPPSRC += $(call target_files,$(USRSRC),*.cpp)

# Find all build.mk makefiles in each source directory in the src tree.
SRC_MAKEFILES := $(call rwildcard,$(SRC_DIR),build.mk)

# Put together a list of all the sub-directories inside $(SRC_DIR). This will be
# used in order to create the build directory structure.
SRC_DIRS := $(subst $(SRC_DIR)/,,$(sort $(dir $(wildcard $(SRC_DIR)/*/*))))


################################################################################
# Settings
################################################################################


################################################################################
# Inclusions
################################################################################

# Toolchains and platform specific commands.
include $(SELF_DIR)tools.mk

# Include all build.mk defines source files.
include $(SRC_MAKEFILES)


################################################################################
# Tool Flags
################################################################################

# Compiler flags
CFLAGS =  -g3 -gdwarf-2 -Os -mcpu=cortex-m3 -mthumb 
CFLAGS += $(patsubst %,-I$(SRC_DIR)%,$(INCLUDE_DIRS)) -I.
CFLAGS += -ffunction-sections -Wall -fmessage-length=0

# Flag compiler error for [-Wdeprecated-declarations]
CFLAGS += -Werror=deprecated-declarations

# Generate dependency files automatically.
CFLAGS += -MD -MP -MF $@.d

# Target specific defines
# CFLAGS += -DUSE_STDPERIPH_DRIVER
CFLAGS += -DSTM32F10X_MD
CFLAGS += -D__CORTEX_M3
CFLAGS += -D__CMSIS_RTOS

# C++ specific flags
CPPFLAGS += -fno-rtti -fno-exceptions

# Linker flags
LDFLAGS += -T$(PROJECT_DIR)linker_stm32f10x.ld -Xlinker
LDFLAGS += --gc-sections -Wl,-Map,$(TARGETDIR)$(TARGET).map
LDFLAGS += --specs=rdimon.specs -lc -lnosys
LDFLAGS += -u _printf_float 

# Assembler flags
ASFLAGS =  -g3 -gdwarf-2 -mcpu=cortex-m3 -mthumb 
ASFLAGS += -x assembler-with-cpp -fmessage-length=0

# Collect all object and dep files
ALLOBJ += $(addprefix $(BUILD_DIR), $(CSRC:.c=.o))
ALLOBJ += $(addprefix $(BUILD_DIR), $(CPPSRC:.cpp=.o))
ALLOBJ += $(addprefix $(BUILD_DIR), $(ASRC:.s=.o))

ALLDEPS += $(addprefix $(BUILD_DIR), $(CSRC:.c=.o.d))
ALLDEPS += $(addprefix $(BUILD_DIR), $(CPPSRC:.cpp=.o.d))
ALLDEPS += $(addprefix $(BUILD_DIR), $(ASRC:.s=.o.d))


################################################################################
# Targets
################################################################################

all: elf hex bin size

elf: $(TARGETDIR)$(TARGET).elf

bin: $(TARGETDIR)$(TARGET).bin

hex: $(TARGETDIR)$(TARGET).hex

# Display size
size:
	@$(SIZE) $(TARGETDIR)$(TARGET).elf \
	 		 $(TARGETDIR)$(TARGET).hex \
	 		 --format=berkeley -d $<

# Create a hex file from ELF file
%.hex : %.elf
	@echo Building $(notdir $@)...
	@$(OBJCOPY) -O ihex $< $@

# Create a bin file from ELF file
%.bin : %.elf
	@echo Building $(notdir $@)...
	@$(OBJCOPY) -O binary $< $@

# Create an elf file
$(TARGETDIR)$(TARGET).elf : $(ALLOBJ)
	@echo Building $(notdir $@)...
	@$(CPP) $(CFLAGS) $(ALLOBJ) --output $@ $(LDFLAGS)

clean:
	@echo Cleaning...
	@-$(RMDIR) $(call fixdir,$(TARGETDIR))
	@-$(RMDIR) $(call fixdir,$(BUILD_DIR))
	@-$(MKDIR) $(call fixdir,$(TARGETDIR))
	@-$(MKDIR) $(call fixdir,$(addprefix $(BUILD_DIR)/, $(SRC_DIRS)))


################################################################################
# Tool Invocations
################################################################################

# C compiler to build .o from .c in $(BUILD_DIR)
$(BUILD_DIR)%.o : $(SRC_DIR)%.c
	@echo Compiling $(notdir $<)...
	@$(CC) $(CFLAGS) -c -o $@ $<

# CPP compiler to build .o from .cpp in $(BUILD_DIR)
# Note: Calls standard $(CC) - gcc will invoke g++ if appropriate
$(BUILD_DIR)%.o : $(SRC_DIR)%.cpp
	@echo Compiling $(notdir $<)...
	@$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

# Assember to build .o from .s in $(BUILD_DIR)
$(BUILD_DIR)%.o : $(SRC_DIR)%.s
	@echo Assembling $(notdir $<)...
	@$(CC) $(ASFLAGS) -c -o $@ $<


.PHONY: all clean elf bin hex size

.SECONDARY:

# Include auto generated dependency files
-include $(ALLDEPS)