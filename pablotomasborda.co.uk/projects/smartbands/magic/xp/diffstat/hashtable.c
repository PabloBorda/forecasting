/**
   Author: Pablo Tomas Borda Di Berardino
   Company: Developers Associates
**/
#include "hashtable.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int isValuePresent(struct Hashtable *h,char *value){
  int key = hash(h,value);
  char **possiblePos = (h->value + (key*sizeof(char *)));
  char *table_element = *possiblePos;
  if (strcmp(table_element, value)==0) {
    return 1;
  } else {
    int found_element = 1;
    int counter = 0;
    while ((strcmp(*(possiblePos + (counter*sizeof(char *))),value)!=0) &&
           (strcmp(*(possiblePos + (counter*sizeof(char *)))," ")!=0) &&
           (found_element!=0)){
      if (counter < h->size){
        counter = counter++;
      }
      if (counter == h->size) {
        counter = 0;
      }
      if (counter == (key-1)) {
        found_element = 0;
      }
    }
    if (found_element == 0) {
      return 0;
    }
  }
}



/*
  returns 0 if the number is more or less prime
  returns -1 if the number is more or less not prime
*/
int isMoreOrLessPrime(long x){
  if ( (x % 2)==0 || (x % 3)==0 || (x % 5)==0 ) {
    return -1;
  } else {
    return 0;
  }
}



int closestPrimeNumber(long x){
  while (isMoreOrLessPrime(x) == -1){
   x = x + 1;
  }
  return x;
}


void init(struct Hashtable *h, long size){
  h->size = closestPrimeNumber(size);
  h->collision = 0;
  h->inserted = 0;
  if ((h->value = malloc(sizeof(char *)*h->size)) == NULL){
    printf("Not enough memory to init hash table man\n");
  } else {
    int j;
    for (j=0;j<h->size;j++){
      *(h->value + j*sizeof(char *)) = " ";
    }
    //printAllElements(h);
  }
}


int hash(struct Hashtable *h,char *str){
  char *init = str;
  int sum = 0;
  int x = 0;
  while (*init != '\0' && *init != '\n'){
    sum = sum + *init;
    init = init + 1;
  }
  int res = (sum % h->size);
  return (res>0)?res:(res*-1);
}



void printAllElements(struct Hashtable *h){
  int i;
  char **current;
  current = h->value;
  for (i=0;i<h->size;i++){
    if (strcmp(*current," ")!=0){
      printf("%d)-> %s\n",i,*current);
    }
    if ((current + sizeof(char *)) < (h->value + (h->size*sizeof(char *)))){
      current = current + sizeof(char *);
    }
  }


}

long hsize(struct Hashtable *h){
  return (h->size*sizeof(char *));

}

void insert(struct Hashtable *h,char *str){
  char *space = " \0";
  if (*str != '\n'){
    int key = hash(h,str); 
    char **possiblePos = (h->value + (sizeof(char *)*key));
    if (strcmp(*possiblePos,str)!=0){
        if (strcmp(*possiblePos,space) != 0){
          //printf("Element %s causes collision with %s\n",str,*possiblePos);
          h->collision = h->collision + 1;
          while ((strcmp(*possiblePos,space) == 0) && (possiblePos < (h->value + (h->size + sizeof(char *)*key)))){
            possiblePos = possiblePos + sizeof(char *);
          }
        }
        *possiblePos = str;
        //printf("Element %s successfully inserted at: %d\n",str,key);
        h->inserted = h->inserted + 1;
   } else {
     //printf("This element %s has previously been inserted");
   }
  }
}

char* valueAt(struct Hashtable *h,int pos){
  return *(h->value + sizeof(char *)*pos);
}
