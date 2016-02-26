#include "commons.h"
#include <string.h>
#include <sys/stat.h>

long checksum(char *wrd)
{
  long sum = 0;
  for (int i=0;i<strlen(wrd);i++){
    sum = sum + wrd[i];
  }
  return sum;
}


long getFileSize(const char *file){
  struct stat results;
  if (stat(file, &results) == 0){
    return results.st_size;
  } else {
    return -1;
  }
}


