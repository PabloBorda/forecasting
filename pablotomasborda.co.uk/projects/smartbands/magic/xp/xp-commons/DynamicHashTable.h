#ifndef DYNAMICHASHTABLE_H
#define DYNAMICHASHTABLE_H

#include "Bucket.h"
#include "HashRecord.h"
#include <list>
#include <iostream>




namespace persistance {

 
  class HashRecord;
 
  class Bucket;

  class DynamicHashTable{
    private:
      char *name; // by the time only emails
      short globaldebt;
      long buckets_amount;
      long records_amount;
      FILE *directory; // here go all bucket addresses
      long getBucketAddr(long hashcode);   // reads the address of the bucket at position hashcode
      std::list<DynamicHashTable *> childs; // I plan to build a huge tree of hashtables in order to group siimilar behaviours among users
    public:
      DynamicHashTable(const char *name); // if the file does not exist, creates a new one, else the existing one is used
      ~DynamicHashTable();
      void insert(HashRecord *value);
      bool contains(HashRecord *value);
      short compare(DynamicHashTable *anotherHashTable);
      std::list<DynamicHashTable *> getChilds();
      void setChilds(std::list<DynamicHashTable *> tables);
      void appendChild(HashRecord *value);
      long hash(const char *data);
      short getGlobaldebt() const
      {

    	  short tmp;
    	  fread(&tmp,1,sizeof(int),this->directory);
          return globaldebt;
      }

      void setGlobaldebt(short  globaldebt)
      {

          this->globaldebt = globaldebt;
          fwrite(&globaldebt,1,sizeof(int),this->directory);
      }

  };



};




#endif
