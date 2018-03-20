#ifndef __SHELL_H__
#define __SHELL_H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <errno.h>
#include <ctype.h>
#include <sys/types.h>

//the maximum length of command line input
#define MAX_CMDLINE 1024
//the maximum parsable commands
#define MAX_PARSED_CMD 128
//the maximum number of arguments
#define MAX_ARGUMENT 16

struct sigaction act;
const char* PS1 = "prompt > ";
char cmdline_input[MAX_CMDLINE + 1];

//Function will parse & trim the command line and use fork to process multiple
//commands at a same time. Execution of each command will be dealt by execute_cmd function.
void execute_cmdline();

//This is the actual function that will be used by child process to run each shell command
void execute_cmd(char *cmd);

//the original code was written by Adam Rosenfield
//from https://stackoverflow.com/questions/122616/how-do-i-trim-leading-trailing-whitespace-in-a-standard-way
size_t trim_whitespace(char *out, size_t len, const char *str);

//capturing signal(SIGINT to be exact) means one of the parsed commands is "quit" command
//when "quit" command is captured,
//parent process will wait till any other child process(rest of the commands) to finish it's work and terminate itself.
static void sig_fn(int signo);

#endif
