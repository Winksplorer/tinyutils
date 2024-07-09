# Define the utilities
UTILS = tinyshutdown

# Define directories
OBJ_DIR = obj
BIN_DIR = bin

# Define compiler and linker flags
NASM = nasm
NASMFLAGS = -felf64 -dTINY_VER=\"v$(shell date +%y%m%d)\"
LD = ld
LDFLAGS = -nostdlib -n
STRIP = strip
STRIPFLAGS = --strip-all

# Define default target
all: $(UTILS)

# Pattern rule to build each utility
$(UTILS): %: $(OBJ_DIR)/%.o
	@mkdir -p $(BIN_DIR)
	$(LD) $< $(LDFLAGS) -o $(BIN_DIR)/$@
	$(STRIP) $(STRIPFLAGS) $(BIN_DIR)/$@

# Pattern rule to build object files
$(OBJ_DIR)/%.o: %.asm
	@mkdir -p $(OBJ_DIR)
	$(NASM) $< -o $@ $(NASMFLAGS)

# Clean target
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

.PHONY: all clean $(UTILS)
