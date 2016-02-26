#ifndef DYNAMICHASHTABLETEST_H
#define DYNAMICHASHTABLETEST_H

#include <cppunit/TestFixture.h>
#include <cppunit/extensions/HelperMacros.h>
#include "../DynamicHashTable.h"


/*
 * =====================================================================================
 *        Class:  DynamicHashTableTest
 *  Description:  This class tests the DynamicHashTable main functionality
 * =====================================================================================
 */
class DynamicHashTableTest : public CPPUNIT_NS :: TestFixture

{
    CPPUNIT_TEST_SUITE (DynamicHashTableTest);
    CPPUNIT_TEST (testContains);
    CPPUNIT_TEST (testRetrieve);
    CPPUNIT_TEST (testHashCode);
    CPPUNIT_TEST_SUITE_END ();

    public:
      void setUp(void);
      void tearDown(void);
    public:
		/* ====================  LIFECYCLE     ======================================= */
		DynamicHashTableTest ();                             /* constructor */

                void testContains();
		void testRetrieve();
		void testHashCode();


		/* ====================  ACCESSORS     ======================================= */

		/* ====================  MUTATORS      ======================================= */

		/* ====================  OPERATORS     ======================================= */

	protected:
		/* ====================  DATA MEMBERS  ======================================= */

	private:

	  persistance::DynamicHashTable *t;
		/* ====================  DATA MEMBERS  ======================================= */

}; /* -----  end of class DynamicHashTableTest  ----- */


#endif
