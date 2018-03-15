#include "shell.h"

int main(int argc, char **argv)
{
	if (argc == 1) {//Interactive mode
		while(1) {
			printf("%s", PS1);
			if (fgets(cmdline_input, MAX_CMDLINE, stdin) == NULL) {
				return 0;
			}
			printf("%s", cmdline_input);
			execute_cmdline();
		}
	}
	else if (argc == 2){//Batch mode

	}
	else {
		printf("\t\tUSAGE\n");
		printf("Interactive mode: %s\n", argv[0]);
		printf("Batch mode: %s [batchFile]\n", argv[0]);
	}
}

void execute_cmdline()
{
	char* parsed_cmd;

	parsed_cmd = strtok(cmdline_input, ";");
	while(parsed_cmd != NULL) {
		printf("%s\n", parsed_cmd);
		parsed_cmd = strtok(NULL, ";");
	}
}