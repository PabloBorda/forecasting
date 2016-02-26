#include "HashDynamicRecord.h"
#include <stdio.h>
#include <string.h>


using namespace persistance;
using namespace std;

HashDynamicRecord::HashDynamicRecord(): HashRecord(){

}


HashDynamicRecord::HashDynamicRecord(string content): HashRecord(content){
}
      


HashDynamicRecord::HashDynamicRecord(const char *content,long pos): HashRecord(content){   // this constructor is used in case you want to retrieve the record from a file




}

HashDynamicRecord::~HashDynamicRecord(){

}


