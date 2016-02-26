#ifndef HASHSTATICRECORD_H
#define HASHSTATICRECORD_H
 
#include "HashRecord.h"
#include "config.h"
#include <string>

namespace persistance {
      
        using namespace std;
        
        class HashRecord;
 
        class HashStaticRecord: public HashRecord {

            private:
              void generate_empty_info();
              char empty_value[RECORD_SIZE+1];
	        public:
              HashStaticRecord();
	          HashStaticRecord(const char * content);
	          HashStaticRecord(string fname,long pos);   // this constructor is used in case you want to retrieve the record from a file
	          ~HashStaticRecord();
              bool compare(HashRecord *r);
              long getSize();
              void setFileName(string fname);
              bool empty();
	};



};








#endif
