# Directories 'make' searches in
VPATH = $(SHARED_DIR)
# Directories 'CC' looks for dependencies
INCLUDES = $(patsubst %,-I%, . $(SHARED_DIR))

# Be silent per default, but 'make V=1' will show all compiler calls.
# If you're insane, V=99 will print out all sorts of things.
V?=0
ifeq ($(V),0)
	Q := @
	NULL := 2>/dev/null
endif

###########################
# Collecting object files #
###########################
OBJS = $(CFILES:%.c=$(BUILD_DIR)/bin/%.o)
OBJS += $(CXXFILES:%.cpp=$(BUILD_DIR)/bin/%.o)
OBJS += $(AFILES:%.S=$(BUILD_DIR)/bin/%.o)

#################
# Default flags #
#################
# Improved make functionality using -MD -MMD -MP
DEFAULT_CPPFLAGS += -MD -MMD -MP
DEFAULT_CPPFLAGS += -Werror -Wall -Wundef
DEFAULT_CPPFLAGS += $(INCLUDES)

DEFAULT_CFLAGS += $(OPT) $(CSTD) -ggdb3
DEFAULT_CFLAGS += $(ARCH_FLAGS)
DEFAULT_CFLAGS += -ffreestanding
DEFAULT_CFLAGS += -fno-common
DEFAULT_CFLAGS += -ffunction-sections -fdata-sections
DEFAULT_CFLAGS += -Wextra -Wshadow -Wno-unused-variable -Wimplicit-function-declaration
DEFAULT_CFLAGS += -Wredundant-decls -Wstrict-prototypes -Wmissing-prototypes

DEFAULT_CXXFLAGS += $(OPT) $(CXXSTD) -ggdb3
DEFAULT_CXXFLAGS += $(ARCH_FLAGS)
DEFAULT_CXXFLAGS += -fno-common
DEFAULT_CXXFLAGS += -ffunction-sections -fdata-sections
DEFAULT_CXXFLAGS += -Wextra -Wshadow -Wredundant-decls  -Weffc++

DEFAULT_ASFLAGS += $(OPT) $(ARCH_FLAGS) -ggdb3

DEFAULT_LDFLAGS += -T$(LDSCRIPT) -nostartfiles
DEFAULT_LDFLAGS += $(ARCH_FLAGS)
DEFAULT_LDFLAGS += -specs=nano.specs
# Passing options to linker using -Wl
# gc-sections turns on garbage collection of unused input sections
DEFAULT_LDFLAGS += -Wl,--gc-sections
ifeq ($(V),99)
DEFAULT_LDFLAGS += -Wl,--print-gc-sections
endif


####################
# Makefile targets #
####################
all: gccversion $(BUILD_DIR)/$(PROJECT).elf $(BUILD_DIR)/$(PROJECT).bin
dump: $(BUILD_DIR)/$(PROJECT).list $(BUILD_DIR)/$(PROJECT).lss $(BUILD_DIR)/$(PROJECT).s

.PHONY: all clean dump gccversion

# Display compiler version information.
gccversion :
	@printf "  GC\tversion\t$<\n"
	@$(CC) --version

clean:
	rm -rf $(BUILD_DIR)


#####################
# Compiling sources #
#####################
# Compile: create object files from C source files.
$(BUILD_DIR)/bin/%.o: %.c
	@printf "  CC\t$<\n"
	@mkdir -p $(dir $@)
	$(Q)$(CC) $(DEFAULT_CFLAGS) $(CFLAGS) $(DEFAULT_CPPFLAGS) $(CPPFLAGS) -o $@ -c $<

# Compile: create object files from C++ source files.
$(BUILD_DIR)/bin/%.o: %.cpp
	@printf "  CXX\t$<\n"
	@mkdir -p $(dir $@)
	$(Q)$(CC) $(DEFAULT_CXXFLAGS) $(CXXFLAGS) $(DEFAULT_CPPFLAGS) $(CPPFLAGS) -o $@ -c $<

# Compile: create object files from assembly source files.
$(BUILD_DIR)/bin/%.o: %.S
	@printf "  AS\t$<\n"
	@mkdir -p $(dir $@)
	$(Q)$(CC) $(DEFAULT_ASFLAGS) $(ASFLAGS) $(DEFAULT_CPPFLAGS) $(CPPFLAGS) -o $@ -c $<

# Linking: create ELF output file from object files.
$(BUILD_DIR)/$(PROJECT).elf: $(OBJS) $(LDSCRIPT)
	@printf "  LD\t$@\n"
	$(Q)$(LD) $(DEFAULT_LDFLAGS) $(LDFLAGS) $(OBJS) $(LDLIBS) -o $@

# Create final output files .bin from ELF output file.
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf
	@printf "  OBJCOPY\t$@\n"
	$(Q)$(OBJCOPY) -O binary  $< $@


############################
# Creates objdump listings #
############################
# Create extended listing file from ELF output file.
$(BUILD_DIR)/%.lss: $(BUILD_DIR)/%.elf
	@printf "  OBJDUMP\t$@\n"
	$(Q)$(OBJDUMP) -h -S $< > $@

# Create extended listing file from ELF output file.
$(BUILD_DIR)/%.list: $(BUILD_DIR)/%.elf
	@printf "  OBJDUMP\t$@\n"
	$(Q)$(OBJDUMP) -S $< > $@

# Create extended listing file from ELF output file.
$(BUILD_DIR)/%.s: $(BUILD_DIR)/%.elf
	@printf "  OBJDUMP\t$@\n"
	$(Q)$(OBJDUMP) -D $< > $@


-include $(OBJS:.o=.d)
