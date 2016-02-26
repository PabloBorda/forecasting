#include "DynamicHashTableTest.h"




CPPUNIT_TEST_SUITE_REGISTRATION(DynamicHashTableTest);


using namespace persistance;



DynamicHashTableTest::DynamicHashTableTest() {

}



	void
DynamicHashTableTest::setUp ()
{
    t = new persistance::DynamicHashTable("myDynamicHashTable");
	return ;
}		/* -----  end of method DynamicHashTableTest::setUp  ----- */



	void
DynamicHashTableTest::tearDown ()
{
	return ;
}		/* -----  end of method DynamicHashTableTest::tearDown  ----- */


        void
DynamicHashTableTest::testContains ()
{

    HashStaticRecord *sr1 = new HashStaticRecord("HolaAmigo");
    HashStaticRecord *sr2 = new HashStaticRecord("ChauAmigo");


    t->appendChild((HashRecord *)sr1);
    t->appendChild((HashRecord *)sr2);
    CPPUNIT_ASSERT(t->contains(new HashStaticRecord("ChauAmigo")));
    return ;
}		/* -----  end of method DynamicHashTableTest::testContains  ----- */



	void
DynamicHashTableTest::testRetrieve ()
{
	return ;
}		/* -----  end of method DynamicHashTableTest::testRetrieve  ----- */



	void
DynamicHashTableTest::testHashCode ()
{


	printf("This is the hash code %ld for the string HolaAmigo!: ",t->hash("HolaAmigo!"));

	return ;
}		/* -----  end of method DynamicHashTableTest::testHashCode  ----- */

