#include "HashStaticRecordTest.h"
#include "../HashStaticRecord.h"
#include "../config.h"

CPPUNIT_TEST_SUITE_REGISTRATION(HashStaticRecordTest);


using namespace persistance;
using namespace std;


void HashStaticRecordTest::setUp(void){
  r1 = new HashStaticRecord("HelloHashStaticRecord0");
  r2 = new HashStaticRecord("HelloHashStaticRecord1");
  r3 = new HashStaticRecord("HelloHashStaticRecord2");
  r4 = new HashStaticRecord("HelloHashStaticRecord3");
  r5 = new HashStaticRecord("HelloHashStaticRecord4");
  r6 = new HashStaticRecord("Overriding!!");
  r7 = new HashStaticRecord("Overriding!!");
  

}

void HashStaticRecordTest::tearDown(void){

}

void HashStaticRecordTest::testCompareRecord(){
   CPPUNIT_ASSERT((r1->compare(r3))==false);
   CPPUNIT_ASSERT(r6->compare(r7));
}

void HashStaticRecordTest::testPersist(){
 r1->append("testPersist.txt");
 r2->append("testPersist.txt");
 r3->append("testPersist.txt");
 r4->append("testPersist.txt");
 r5->append("testPersist.txt");
 r6->persist("testPersist.txt",2);
 HashStaticRecord *pick_from_file = new HashStaticRecord("testPersist.txt",3);
 printf("\n I got the following info from testPersist.txt : %s",pick_from_file->getInfo() );
  
 HashStaticRecord *pick_from_file2 = new HashStaticRecord("testPersist.txt",2);
 printf("\n I got the following info from testPersist.txt : %s",pick_from_file2->getInfo() );
 

 CPPUNIT_ASSERT(pick_from_file->compare(r4)==true);
 CPPUNIT_ASSERT(pick_from_file2->compare(r6)==true);



}




