// ************************************************************************
// *****           Template for ANSI C console application.           *****
// ************************************************************************

#include <math.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>

// for fixed-size integers, e.g. int8_t, uint32_t etc.
#include <stdint.h>

// ------------------------------------------------------------------------
int main(int argc, char* argv[])
{
  printf("environment variables:\n");
  for(int i=0; environ[i] != 0; i++)
    printf("%d: %s\n", i, environ[i]);
  printf("\n");

  char *path = getenv("PATH"); // get environment variable
  if(path)
    printf("file search path:\n%s\n\n", path);

  if(argc > 1) {  // command line parameter given?
    clock_t start_time = clock();

    FILE* file = fopen(argv[1], "r"); // open file for reading
    if(file == 0) {
      fprintf(stderr, "ERROR: Cannot open file '%s'.\n", argv[1]);
      return -1;
    }

    int no = 0;
    char line[1024];
    while(fgets(line, sizeof(line), file)) { // read file line by line
      no++;                                 // count line number
      printf("%2d: %s", no, line);         // print line including linefeed
    }
    fclose(file);

    printf("elapsed time: %g ms\n", difftime(clock(), start_time));
    return 0;
  }


  struct dirent *de;      // directory entry
  DIR *dir = opendir("."); // open a directory
  if(dir) {
    while((de = readdir(dir)) != 0) // print all directory entries
      printf("%s\n", de->d_name);
    closedir(dir); 
  }   
  return 0;
}
