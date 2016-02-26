/*
              diffstat: Implemented by Pablo Tomas Borda Di Berardino
              Company: Developers Associate

*/

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <sys/stat.h>
#include "diffstat.h"
#include "hashtable.h"



/* filesize() returns -1 on error, filesize (>=0) on success,
* and calls exit(EXIT_FAILURE) when fclose() fails. */

long fileSize(FILE *file)
{

  struct stat info;
  fstat(file,&info);
  return (long)info.st_size;
}

long countWords(FILE *f)
{
  char c;
  int words = 0;
  rewind(f);
  if (!feof(f)){
    c = fgetc(f);
  }
  while (!feof(f)){
   if (c == ' '){
     c = fgetc(f);
     words = words + 1;
     while (c == ' '){
       c = fgetc(f);
     }
   }
   c = fgetc(f);
  }
  return words;

}

float compare(char *file1, char *file2){
  FILE *f1;
  if ((f1 = fopen(file1,"rb")) == NULL) {
   printf("Error opening file ",file1);
  } else 
    rewind(f1);

  char c[1];
  c[1] = '\0';
  int count=0;
  int newWord;
  int wordsize=0;  
  char *Word = (char *)malloc(1024);
  struct Hashtable h;
  int wordsF1 = countWords(f1);
  rewind(f1);
  init(&h,wordsF1);
  if (!feof(f1)) {
    c[0] = fgetc(f1);
    count = count++;
  }
  if (c[0] == ' '){
    newWord=-1;
  }
  while (!feof(f1)){
    while ((c[0] == ' ') || (c[0] == '\n')) {  /* Add more characters to skip in the comparison */
      if (newWord == 0) {
        wordsize=0;
        strcat(Word,"\0");
        insert(&h,Word);
        Word = NULL;
        Word = malloc(1024);
        newWord=-1;
      }
      count = count++;
      c[0] = fgetc(f1);
    }
    newWord = 0;
    char d[1];
    int l = strlen(Word);
    *(Word + l) = d[1];
    count = count++;
    wordsize=wordsize++;
    c[0] = fgetc(f1);
   }
// Processing second file
  FILE *f2;
  int matches = 0;
  if ((f2 = fopen(file2,"rb")) == NULL) {
   printf("Error opening file ",file2);
  } else
    rewind(f2);

  char *WordF2 = (char *)malloc(1024);
  count = 0;
  int wordsF2 = countWords(f2);
  rewind(f2);
  if (!feof(f2)) {
    c[0] = fgetc(f2);
    count = count++;
  }
  if (c[0] == ' '){
    newWord=-1;
  }

  while (!feof(f2)){
    while ((c[0] == ' ') || (c[0] == '\n')) {
      if (newWord == 0) {
        wordsize=0;
        strcat(WordF2,"\0");
        if (isValuePresent(&h,WordF2)==1){
          matches = matches + 1;
        }
        WordF2 = NULL;
        WordF2 = malloc(1024);
        newWord=-1;
      }
      count = count++;
      c[0] = fgetc(f2);
    }
    newWord = 0;
    char d[1];
    int l = strlen(WordF2);
    *(WordF2 + l) = d[1];
    count = count++;
    wordsize=wordsize++;
    c[0] = fgetc(f2);
   }
   //printf("The number of matches for this comparison is : %d, The first file has %d words, and the second has %d\n",matches,wordsF1,wordsF2);
   return ((matches*100/(wordsF1+wordsF2))*2);
 // printAllElents(&h);
 // assert(isValuePresent(&h,"world")==1);
}




int main(int argc, char *argv[])
{
  char *file1;
  char *file2;
  //printf("WELCOME TO DIFFSTAT\n");
  if (argv[1] != NULL && argv[2] != NULL){
    printf("%f\n",compare(argv[1],argv[2]));
  } else
    printf("USAGE: diffstat file1 file2\n");

  return EXIT_SUCCESS;
}
