#include "shell.h"

int main(int argc, char **argv)
{
	//signal handling is to capture the SIGINT sent from child process
	act.sa_handler = sig_fn;
	sigfillset(&act.sa_mask);

	if (argc == 1) {//Interactive mode
		while(1) {
			printf("%s", PS1);
			if (fgets(cmdline_input, MAX_CMDLINE, stdin) == NULL) {
				//when nothing but "ctrl + D" is pressed, EOF will cause trouble with fgets.
				return 0;
			}
			// printf("%s", cmdline_input);
			execute_cmdline();
		}
	}
	else if (argc == 2){//Batch mode
		FILE *fp = NULL;
		fp = fopen(argv[1], "r");
		if (fp == NULL) {
			fprintf(stderr, "FILE open error\n");
			exit(0);
		}
		while(1) {//until EOF is reached
			if (fgets(cmdline_input, MAX_CMDLINE, fp) == NULL) {
				//fgets() == NULL means EOF. Therefore terminate.
				return 0;
			}
			execute_cmdline();
		}
	}
	else {//more than 2 arguments for the program is received.
		printf("Only one batchfile can be processed at a time.\n");
		printf("\t\tUSAGE\n");
		printf("Interactive mode: %s\n", argv[0]);
		printf("Batch mode: %s [batchfile]\n", argv[0]);
	}
}

void execute_cmdline()
{
	pid_t pid;
	char* parsed_cmd;
	char trimmed_cmd[MAX_PARSED_CMD];

	parsed_cmd = strtok(cmdline_input, ";");
	while (parsed_cmd != NULL) {//parse all commands separated by ";"
		switch (pid = fork()) {
			case -1: //error on fork()
				fprintf(stderr, "failed to create child process\n");
				fprintf(stderr, "%s\n", strerror(errno));
				break;
			case 0: //child process
				//child process will run command via execute_cmd().
				//before that it trims any unnecessary whitespace before & after command using trim_whitespace() function
				if (strlen(parsed_cmd) > MAX_PARSED_CMD) {
					fprintf(stderr, "cannot parse command longer than %d characters\n", MAX_PARSED_CMD);
					exit(0);
				}
				trim_whitespace(trimmed_cmd, MAX_PARSED_CMD, parsed_cmd);
				printf("%s\n", trimmed_cmd);
				execute_cmd(trimmed_cmd);//execution of each command will be handled by diffrent function.
				exit(0);
				break;
			default: //parent process
				//does nothing and continue to parse commandline
				break;
		}
		parsed_cmd = strtok(NULL, ";");
	}
	//wait for all child processes(commands) to be finished
	while(wait(NULL) > 0);
}

void execute_cmd(char *cmd)
{
	// fprintf(stdout,"%s\n", cmd);
	char *parsed_argv;
	int argc = 0;
	char **argv;

	argv = (char**)malloc(sizeof(char*) * MAX_ARGUMENT + 1);
	for (int i = 0; i < MAX_ARGUMENT; ++i)
		argv[i] = (char*)malloc(sizeof(char) * (MAX_PARSED_CMD + 1));
	//carefully free all memories in case of any error to prevent memory-leak.

	parsed_argv = strtok(cmd, " ");
	while(parsed_argv != NULL) {//parse all arguments from commands and save it on argv
		if (strlen(parsed_argv) > MAX_PARSED_CMD) {//parsed argv is too long
			fprintf(stderr, "each argument for command cannot exceed %d.\n", MAX_PARSED_CMD);
			for (int i = 0; i < MAX_ARGUMENT + 1; ++i)
				free(argv[i]);
			free(argv);
			return;
		}
		strncpy(argv[argc++], parsed_argv, strlen(parsed_argv));
		// printf("argv[%d]:[%s]\n", argc-1, argv[argc-1]);
		if (argc == 1) {//check the command if it is "quit"
			for (int i = 0; argv[0][i]; ++i)
				argv[0][i] = tolower(argv[0][i]);
			if (!strcmp(argv[0], "quit")) {
				//if the command is quit, free all resources and send SIGINT to
				//parent process. Parent will be terminated after processing remaining commands.
				for (int i = 0; i < MAX_ARGUMENT + 1; ++i)
					free(argv[i]);
				free(argv);
				kill(getppid(), SIGINT);
				return;
			}
		}
		if (argc >= MAX_ARGUMENT) {//too many arguments error
			fprintf(stderr, "number of arguments must be less than %d.\n", MAX_ARGUMENT);
			for (int i = 0; i < MAX_ARGUMENT + 1; ++i)
				free(argv[i]);
			free(argv);
			return;
		}
		parsed_argv = strtok(NULL, " ");
	}
	//after parsing all arguments, make sure to free unused memories,
	//and put NULL at the end of argv before pass execvp.
	for (int i = argc; i < MAX_ARGUMENT + 1; ++i)
		free(argv[i]);
	argv[argc] = NULL;

	if (execvp(argv[0], argv) == -1) {
		//if execvp behaves properly, it will execute command and free all memories that it had at the execution time, but if there is an error, I must take the responsibility to free allocated memory.
		fprintf(stderr, "Failed to execute execvp\n");
		fprintf(stderr, "command: %s\n", argv[0]);
		for (int i = 0; i < argc; ++i)
			free(argv[i]);
		free(argv);
		kill(getpid(), SIGINT);
	}
}

size_t trim_whitespace(char *out, size_t len, const char *str)
{
	if(len == 0)
		return 0;

	const char *end;
	size_t out_size;

	// Trim leading space
	while(isspace((unsigned char)*str)) str++;

	if(*str == '\0')  // All spaces?
	{
		*out = '\0';
		return 1;
	}

	// Trim trailing space
	end = str + strlen(str) - 1;
	while(end > str && isspace((unsigned char)*end)) end--;
	end++;

	// Set output size to minimum of trimmed string length and buffer size minus 1
	out_size = (end - str) < len-1 ? (end - str) : len-1;

	// Copy trimmed string and add null terminator
	memcpy(out, str, out_size);
	out[out_size] = '\0';

	return out_size;
}

static void sig_fn(int signo)
{
	//Simply waits for any remaining child process to finish
	//after all commands are executed, terminate shell
	while(wait(NULL) > 0);
	exit(0);
}
