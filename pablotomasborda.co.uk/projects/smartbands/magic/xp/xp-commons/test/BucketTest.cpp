#include "test/BucketTest.h"
#include "../config.h"


CPPUNIT_TEST_SUITE_REGISTRATION (BucketTest);

using namespace persistance;
using namespace std;


void BucketTest::setUp(){

  b = new persistance::Bucket("myHashTableFile.txt");
  b1 = new persistance::Bucket("myHashTableFile1.txt");
  r = new persistance::HashStaticRecord("ThisIsSampleContent");
  comparator = new Levenshtein();
}

void BucketTest::tearDown(){

}


void BucketTest::testBucketInsert(){
 
  try {
    b->insertAt(r,1);
    b1->insertAt(r,1);
  } catch (int e) {

    std::cout << "I got this exception number : " << e;

  }

  cout << "\nThe number of elements the bucket has is: " << b->size() << "\n";
  for (int i=0;i<= b->size();i++){
    try {

      cout << "\nPrinting array elements at pos " << i << " ";
      if (b->getAt(i)!=NULL){
        cout << "The following element is: " << b->getAt(i)->getInfo();
      } else {
        cout << "NULL";
      }
    } catch (int e) {
      std::cout << "I got this exception number : " << e;
    }

  }

  CPPUNIT_ASSERT_MESSAGE("Testing : b->size()==1\n",b->size()==1);
  CPPUNIT_ASSERT_MESSAGE("Testing : b->size() > 0\n",b->size() > 0);
  CPPUNIT_ASSERT_MESSAGE("Testing : b->contains(r)\n",b->contains(r));
  CPPUNIT_ASSERT_MESSAGE("Testing : !b->filled()\n",!b->filled());
}


void BucketTest::testBucketRetrieve(){
  Bucket *tosave = new Bucket("testBucketRetrieve.txt");
  tosave->append(r);
  tosave->persist();

  Bucket *toRetrieve = new Bucket("testBucketRetrieve.txt",0);

  CPPUNIT_ASSERT(toRetrieve->compare(tosave));

}


void BucketTest::testBucketCompare(){
 
  bool comp = b->compare(b1);
  if (comp) {
    cout << "Bucket comparison is true\n";
  } else {
    cout << "Bucket comparison is false\n";
  }

  CPPUNIT_ASSERT_MESSAGE("Testing b->compare(b1)",comp);
}


void BucketTest::testLevenshtein(){
/*
  CPPUNIT_ASSERT_MESSAGE("Differences between lev1 and lev2 should be one",(comparator->levenshtein("lev1.txt","lev2.txt")==1));

  
  CPPUNIT_ASSERT_MESSAGE("Differences between lev1 and lev2 should be one",(comparator->levenshtein("lev3.txt","lev4.txt")==11));
*/
}




void BucketTest::testPersistBucket(){
  cout << "\nThis is the record info: " << r->getInfo() << "\n";
  b->persist();
  cout << "b->persist(); line passed\n";
  
  persistance::Bucket *b2 = new persistance::Bucket("myHashTableFile.txt",0);
  try {  
    CPPUNIT_ASSERT(b->compare(b2));
    CPPUNIT_ASSERT(b->compare(b2));
    
  } catch (int e) {
    cout << "\n Error inserting record to bucket \n";
  }

}


void BucketTest::testAppend(){

	Bucket *btest = new Bucket("testBucket.txt");
	btest->append(r);
	btest->append(NULL);

    CPPUNIT_ASSERT(btest->size() == 2);

}

