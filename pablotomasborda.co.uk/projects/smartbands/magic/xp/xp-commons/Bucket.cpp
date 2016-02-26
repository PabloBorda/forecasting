#include "Bucket.h"
#include "HashStaticRecord.h"
#include "config.h"
#include <string>
#include <fstream>
#include <iostream>
#include <list>
#include <stdlib.h>
#include <stdio.h>
#include <fstream>
#include <cstring>


using namespace std;
using namespace persistance;

Bucket::Bucket(const char *fname){
  
  this->file_name = fname;
  this->count = 0;

  for (int i=0;i < BUCKET_SIZE; i++){
    this->records[i] = NULL;
  }

}


Bucket::Bucket(const char *fname,long bucket_addr){
  if (bucket_addr < getFileSize(fname)){
    this->file_name = fname;
    this->count = 0;
    for (int i=0;i < BUCKET_SIZE; i++){
      this->records[i] = NULL;
    }
    this->bucket_addr = bucket_addr;
    short remainig_space = 0;
    for (int record_in_bucket=0;record_in_bucket<BUCKET_SIZE;record_in_bucket++){
      HashStaticRecord *r = new HashStaticRecord(fname,calculate_record_position_relative_to_bucket(bucket_addr,record_in_bucket));
      if (strcmp(r->getInfo(),BLANK_SPACE) == 0){
    	records[record_in_bucket] = NULL;
      } else {
        records[record_in_bucket] = r;
      }
    }
  } else {
	  cout << "Error loading bucket, there is no such a bucket";
  }
}



Bucket::~Bucket(){


}


void Bucket::split(){



}

void Bucket::insertAt(HashRecord *record,int pos) throw (int){

  if ((pos < BUCKET_SIZE) && (this->records[pos] == NULL)){
    record->setFileName(this->file_name);
    this->records[pos] = record;
    this->count = this->count + 1;
  } else {

    throw WRONG_INDEX;
  }

}

int Bucket::size(){
 return (this->count);
}




bool Bucket::contains(HashRecord *record){
  
  int i = 0;
  while ((i <= BUCKET_SIZE) && (this->records[i] != NULL) && !(records[i]->compare(record))) {
   i++; 
  }
  return (i <= BUCKET_SIZE);
}


// by the time only works with HashStaticRecord
bool Bucket::filled(){
  HashStaticRecord *empty_record = new HashStaticRecord();
  return !(this->contains(empty_record));
}

HashRecord *Bucket::getAt(int pos) throw (int){
  if ((this->records[pos]) != NULL){
    return this->records[pos];
  } else {
    return NULL;
  }
  throw NOTHING_FOUND;
}

void Bucket::persist(){
  for (int r=0;r<=this->size();r++){
    if (this->records[r] != NULL){
      this->records[r]->persist(string(this->file_name),calculate_record_position_relative_to_bucket(this->bucket_addr,r));
    }
  /*  else {
      persistance::HashStaticRecord *tmp = new HashStaticRecord();
      tmp->persist(string(this->file_name),calculate_record_position_relative_to_bucket(this->bucket_addr,r));
    }*/
 }
}


long Bucket::calculate_record_position_relative_to_bucket(long bucketpos,int record_number){


  return ((bucketpos*BUCKET_SIZE) + (record_number*RECORD_SIZE));

}

bool Bucket::append(HashRecord *record)
{
	if (record != NULL){
		int count = 0;
		while (count < BUCKET_SIZE && records[count] != NULL){
		  count = count + 1;
		}
		if (records[count] == NULL){
			records[count] = record;
			return true;
		} else {
			return false;
		}
	}
}

bool Bucket::compare(persistance::Bucket *anotherBucket){
  
  if (this->size() == anotherBucket->size()){
    int diffs = 0;
    for (int i=0;i<BUCKET_SIZE;i++){
      if ((this->records[i] != NULL) && (anotherBucket->getAt(i) != NULL)){
        if (!this->records[i]->compare(anotherBucket->getAt(i))){
          diffs = diffs + 1;
        }
      } else {
    	  diffs = diffs + 1;
      }
    }
    return (diffs == 0);
  } 
  return false;
}



