#include "HashStaticRecord.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <fstream>
#include "config.h"

using namespace persistance;
using namespace std;



HashStaticRecord::HashStaticRecord():HashRecord(){

	this->size = RECORD_SIZE;
	this->setInfo(NULL);

 
}
 

HashStaticRecord::HashStaticRecord(const char * content):HashRecord(content){
 
  this->size = RECORD_SIZE;
}
      


HashStaticRecord::HashStaticRecord(string fname,long pos):HashRecord(fname,pos){   // this constructor is used in case you want to retrieve the record from a file
  FILE *handle;
  char buff[RECORD_SIZE+1];
  if ((handle = fopen(fname.c_str(),"r"))!=NULL){
    if (fseek(handle,pos*RECORD_SIZE,SEEK_SET)==0){
      for (int i=0;i<RECORD_SIZE;i++){
        buff[i] = fgetc(handle);
      }
      buff[RECORD_SIZE] = '\0';
     // printf("I got %s from file. ",&buff);
     strcpy(info,buff);
    } else {
        printf("Error getting record %ld",pos);
      }  
      fclose(handle);
    } else {  printf("Error seeking file pointer"); }
 
/*
  ifstream record_from_file(fname.c_str(),ios::in|ios::binary);
  record_from_file.seekg(pos*RECORD_SIZE);
  char *tmp = (char *)malloc(RECORD_SIZE);
  record_from_file.read(tmp,RECORD_SIZE);
  this->setInfo(tmp);
  record_from_file.close();
*/
}

HashStaticRecord::~HashStaticRecord(){

}

void HashStaticRecord::generate_empty_info(){
    char *tmp = (char *)malloc(RECORD_SIZE);
    for (int j=0;j<RECORD_SIZE;j++){
      *(tmp + j) = '_';
    }
    strcpy(empty_value,tmp);

}


bool HashStaticRecord::compare(HashRecord *r){
     return (strcmp(info,r->getInfo())==0);
}

long HashStaticRecord::getSize(){
  return RECORD_SIZE;
}

void HashStaticRecord::setFileName(string fname){
  this->file_name = fname;
}

bool HashStaticRecord::empty(){

  return (strcmp(info,empty_value)==0);
}


