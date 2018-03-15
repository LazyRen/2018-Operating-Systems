# Compiler and Compile options.
CC = gcc
CFLAGS = -g -Wall -I $(INC)

# Directories for Compile
SRCDIR=src/
INC=include/
LIBS=lib/
BIN = bin/

# Macros specifying path for compile.
SRCS := $(wildcard $(SRCDIR)*.c) 
OBJS := $(SRCS:.c=.o)

# Compile command.
TARGET = shell

all: $(TARGET)

$(TARGET): $(OBJS)
		$(foreach src, $(SRCS),$(shell $(CC) $(CFLAGS) -o $(src:.c=.o) -c $(src)))
		mkdir -p $(BIN)
		$(CC) $(CFLAGS) -o $(BIN)$@ $^

# Delete binary & object files.
clean:
	rm -f $(OBJS)
	rm -rf $(BIN)
