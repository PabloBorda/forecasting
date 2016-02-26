#include "DynamicHashTable.h"
#include "commons.h"
#include "config.h"
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

using namespace persistance;
using namespace std;


DynamicHashTable::DynamicHashTable(const char *name){

  this->name = (char *)malloc(strlen(name));
  strcpy(this->name,name);
  
  directory = fopen(".directory","rb");
  if (directory == NULL){  // if file does not exist create a new one
	  directory = (FILE *)fopen(".directory","ab+");
	  if (directory == NULL) {
		  cout << "Error creating .directory file, check permissions";
	  }
	  setGlobaldebt(1);
  } else {
	  globaldebt = getGlobaldebt();
  }

  long currentSize = getFileSize(name);
  if (currentSize > 0) {
    buckets_amount = currentSize / BUCKET_SIZE;
    records_amount = currentSize / RECORD_SIZE;
  }
  else {
	  buckets_amount = 0;
	  records_amount = 0;
  }
}


DynamicHashTable::~DynamicHashTable(){

}

void DynamicHashTable::insert(HashRecord *value){
	Bucket *b = new Bucket(this->name,this->hash(value->getInfo()));
    if (!b->contains(value)){
      if (!b->append(value)){
    	  cout << "Collision detected, no more room at bucket";
    	  // run necessary code to handle bucket overflows
      } else {
    	  b->persist();
      }
    }
}






bool DynamicHashTable::contains(HashRecord *value){
  HashStaticRecord *r = new HashStaticRecord(this->name,this->hash(value->getInfo()));
  return (strcmp(r->getInfo(),value->getInfo())==0);
}

short DynamicHashTable::compare(DynamicHashTable *anotherHashTable){
 return 0;
}

list<DynamicHashTable *> DynamicHashTable::getChilds(){
  return this->childs;
}

void DynamicHashTable::setChilds(std::list<DynamicHashTable *> tables){

}

void DynamicHashTable::appendChild(HashRecord *value){
  value->append(this->name);    // appends the HashRecord value to the specified file
}

int power(int a, int b)
{
     int c=a;
     for (int n=b; n>1; n--) c*=a;
     return c;
}


/**
 * @params hashcode get the bucket addr addressed by hashcode
 */

long DynamicHashTable::getBucketAddr(long  hashcode)
{
	long tmp;
	fread(&tmp,hashcode,sizeof(long),directory);
	return tmp;

}

long DynamicHashTable::hash(const char *data){

    int s = strlen(data);
    unsigned int take = this->getGlobaldebt();
    int index = s - 1;
    char current;
    int chars;
    int reminder = take%8;
    int tmp = 0;

    if (reminder > 0){
    	chars = take/8 + 1;    // The amount of bytes to take for the hash
    }

    char *position = (char *)malloc(sizeof(long));
    
    int chars_index = sizeof(long)-1;  // get the char *position last index
    int loopcount = 1;
    for (index;((index>=0) && (chars_index>=0));index--){
	if (loopcount < chars) {
	  current = data[index];     // take from less significant to most
	} else if (loopcount == chars) {
      char mask = ~((char)power(2,8) - (char)power(2,reminder));
      current = data[index] & mask;
	}
	else {
	  current = 0;
	}
        *(position + chars_index) = current;
    	chars_index = chars_index - 1;
	    loopcount = loopcount + 1;
    }

    long *result = (long *)position;
	return *result;

}
