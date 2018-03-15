#include <stdio.h>
#include <string.h>

//the maximum length of command line input
#define MAX_CMDLINE 1024
//the maximum parsable commands
#define MAX_PARSED_CMD 100

const char* PS1 = "prompt > ";
char cmdline_input[MAX_CMDLINE + 1];

void execute_cmdline();