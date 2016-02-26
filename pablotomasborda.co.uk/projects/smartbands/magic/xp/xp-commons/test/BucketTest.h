#ifndef BUCKETTEST_H
#define BUCKETTEST_H

#include <cppunit/TestFixture.h>
#include <cppunit/extensions/HelperMacros.h>
#include "../Bucket.h"
#include "../HashStaticRecord.h"
#include "../levenshtein.h"

using namespace std;

class BucketTest : public CPPUNIT_NS :: TestFixture
{
    CPPUNIT_TEST_SUITE (BucketTest);
    CPPUNIT_TEST (testBucketInsert);
    CPPUNIT_TEST (testBucketRetrieve);
    CPPUNIT_TEST (testPersistBucket);
    CPPUNIT_TEST (testBucketCompare);
    CPPUNIT_TEST (testLevenshtein);

    CPPUNIT_TEST_SUITE_END ();

    public:
      void setUp(void);
      void tearDown(void);

    protected:
      void testBucketInsert();
      void testBucketRetrieve();
      void testPersistBucket();
      void testBucketCompare();
      void testLevenshtein();
      void testAppend();
    private:
      persistance::Bucket *b;
      persistance::HashStaticRecord *r;
      persistance::Bucket *b1;
      Levenshtein *comparator;
}; 

#endif

