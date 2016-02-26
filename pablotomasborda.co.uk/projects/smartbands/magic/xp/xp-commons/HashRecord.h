#ifndef HASHRECORD_H
#define HASHRECORD_H
 
#include <string>
#include <fstream> 
#include "commons.h"
#include "config.h"

namespace persistance{
       
       using namespace std; 

	class HashRecord {
	    private:
	      void fill_with_blanks();
	    protected:
	      char info[RECORD_SIZE+1];
          int size;
          string file_name;
	      bool check_file_integrity(string fname);
	      bool isAccurate(const char *info);
        public:
          HashRecord();
	      HashRecord(const char *content);
	      HashRecord(string fname,long pos);   // this constructor is used in case you want to retrieve the record from a file
	      ~HashRecord();
          void setInfo(const char *info);
          const char *getInfo();
          bool empty();
          void persist(string fname,long where);
	      void append(string fname);
          void setFileName(string fname);
          virtual long getSize();
          virtual bool compare(HashRecord *r);

	};



};








#endif
