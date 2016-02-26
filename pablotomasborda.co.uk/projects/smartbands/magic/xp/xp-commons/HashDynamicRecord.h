#ifndef HASHDYNAMICRECORD_H
#define HASHDYMAMICRECORD_H

#include "HashRecord.h"
#include <string.h>

namespace persistance{

        class HashRecord;

	class HashDynamicRecord:public HashRecord {
	    private:
	      long size;
	    public:
              HashDynamicRecord();
	      HashDynamicRecord(std::string content);
	      HashDynamicRecord(const char *content,long pos);   // this constructor is used in case you want to retrieve the record from a file
	      ~HashDynamicRecord();
//              char *empty_info();
	};



};








#endif
