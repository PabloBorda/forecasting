#ifndef BUCKET_H
#define BUCKET_H

//#include "HashStaticRecord.h"
#include "config.h"
#include "HashStaticRecord.h"
#include <vector>
#include <fstream>

#define WRONG_INDEX 0
#define NOTHING_FOUND 1

namespace persistance{

  class HashRecord;
  class HashStaticRecord;

 
  class Bucket{
    private:
      int count;
      short local_debt;
      long key;
      char *buffer;
      HashRecord *records[BUCKET_SIZE];
      void split();
      const char *file_name;
      long calculate_record_position_relative_to_bucket(long bucketpos,int record_number);
      long bucket_addr;
    public:
      Bucket(const char *fname);
      Bucket(const char *fname,long bucket_addr); //loads bucket at specified bucket address
      ~Bucket();
      void insertAt(HashRecord *record, int pos) throw (int);
      bool append(HashRecord *record);
      int size();
      bool contains(HashRecord *record);
      bool filled(); // true if bucked is full
      HashRecord *getAt(int pos) throw (int);
      void persist(); // this method persists the bucket to a file
      bool compare(persistance::Bucket *anotherBucket);
      long getBucket_addr() const
      {
          return bucket_addr;
      }

      void setBucket_addr(long  bucket_addr)
      {
          this->bucket_addr = bucket_addr;
      }

  };

};

#endif

