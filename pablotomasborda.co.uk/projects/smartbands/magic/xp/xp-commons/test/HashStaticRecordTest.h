#ifndef HASHSTATICRECORDTEST_H
#define HASHSTATICRECORDTEST_H

#include <cppunit/TestFixture.h>
#include <cppunit/extensions/HelperMacros.h>
#include "../HashStaticRecord.h"

class HashStaticRecordTest : public CPPUNIT_NS :: TestFixture
{
    CPPUNIT_TEST_SUITE (HashStaticRecordTest);
    CPPUNIT_TEST (testCompareRecord);
    CPPUNIT_TEST (testPersist);
    CPPUNIT_TEST_SUITE_END ();

    public:
      void setUp(void);
      void tearDown(void);
    protected:
      void testCompareRecord();
      void testPersist();
    private:
      persistance::HashStaticRecord *r1;
      persistance::HashStaticRecord *r2;
      persistance::HashStaticRecord *r3;
      persistance::HashStaticRecord *r4;
      persistance::HashStaticRecord *r5;
      persistance::HashStaticRecord *r6;
      persistance::HashStaticRecord *r7;



};




#endif
 
