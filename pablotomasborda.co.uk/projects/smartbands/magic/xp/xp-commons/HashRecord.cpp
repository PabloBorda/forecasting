#include "HashRecord.h"
#include "config.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include "commons.h"

using namespace persistance;
using namespace std;


HashRecord::HashRecord(){
}
 



HashRecord::HashRecord(const char * content){
  
  this->setInfo(content);
}
      


HashRecord::HashRecord(string fname,long pos){   // this constructor is used in case you want to retrieve the record from a file
  this->file_name = fname;

}

HashRecord::~HashRecord(){

}


void HashRecord::setInfo(const char *info){
  if (info != NULL){
    strcpy(this->info,info);
    fill_with_blanks();
  }
}

const char *HashRecord::getInfo(){
  return this->info;
}

bool HashRecord::check_file_integrity(string fname){
  long fsize = getFileSize(fname.c_str());
  return ((fsize % RECORD_SIZE)==0);
}

void HashRecord::fill_with_blanks(){
      int diff = (this->getSize() - strlen(this->info));
      char whitespace = '_';
      int from = strlen(info);
      int i = from;
      for (i; i < RECORD_SIZE ; i++){
        info[i] = whitespace;
      }
      info[i] = '\0';
}


/**
 *  Appends HashRecord to desired file
 * **/
void HashRecord::append(string fname){
 if (info != NULL){
	  FILE *handle;
	  if ((handle = fopen(fname.c_str(),"a+"))==NULL){
		printf("File %s does not exist\n",fname.c_str());
	  } else {
		fprintf(handle,"%s",info);
		fclose(handle);
	  }
 }
}


bool HashRecord::isAccurate(const char *info){
	int l = strlen(info);
	int count = 0;
	for (int i=0;i<l;i++){
		if (info[i]=='_'){
			count = count + 1;
		}
	}
	return !(count == l);


}
/**
 *  If where == -1 it doest use fseek, and directly appends the record
 *
 * **/

void HashRecord::persist(string fname,long where){
  bool ac = this->isAccurate(info);
  if ((info != NULL) && ac){

	  long fsize = getFileSize(fname.c_str());
	  char *cinfo = (char *)malloc(RECORD_SIZE);

      strcpy(cinfo,info);
	  FILE *handle;
	  if (check_file_integrity(fname)){
		//cursor positioned
		   if ((handle = fopen(fname.c_str(),"r+"))==NULL){
			 printf("File %s does not exist\n",fname.c_str());
		   } else {
			 if (fseek(handle,(where*RECORD_SIZE),SEEK_SET)==0){
			   fprintf(handle,"%s",cinfo);
			   fclose(handle);
			 } else {
				 printf("fseek HashRecord.cpp:54 failed to seek\n");
			 }
		   }
	  }
  }
}

long HashRecord::getSize(){
  return RECORD_SIZE;
}

void HashRecord::setFileName(string fname){
  this->file_name = fname;
}


bool HashRecord::compare(HashRecord *r){

  return true;
}

