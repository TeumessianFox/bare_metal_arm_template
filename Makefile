PROJECT = template

# C files to compile
CFILES = main.c

# A(ssembly) files to compile
AFILES = entry.S

# C++ files to compile
CXXFILES +=

# Path to linker script
LDSCRIPT = ld/basic.ld

# Directories in which to look for .c, .S and .h files
SHARED_DIR = src
SHARED_DIR += include

# Flags for the different compilation steps
CFLAGS   +=
CXXFLAGS +=
CPPFLAGS +=
LDFLAGS  +=

OPT ?= -O2
CSTD ?= -std=c99
BUILD_DIR = build
ARCH_FLAGS = -mthumb -mcpu=cortex-A5 -mfloat-abi=hard #-mfpu=...

# Tool paths
PREFIX?= arm-none-eabi-
CC= $(PREFIX)gcc
LD= $(PREFIX)gcc
OBJCOPY= $(PREFIX)objcopy
OBJDUMP= $(PREFIX)objdump

-include rules.mk
