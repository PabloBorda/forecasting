#include <string>
/*
 * =====================================================================================
 *        Class:  Levenshtein
 *  Description:  
 * =====================================================================================
 */
class Levenshtein
{
	public:


		/* ====================  LIFECYCLE     ======================================= */
		Levenshtein ();                             /* constructor      */
		Levenshtein ( const Levenshtein &other );   /* copy constructor */
		~Levenshtein ();                            /* destructor       */

		/* ====================  ACCESSORS     ======================================= */
                
		
		int levenshtein(const std::string f1,const std::string f2);
                   

		/* ====================  MUTATORS      ======================================= */

		/* ====================  OPERATORS     ======================================= */

		Levenshtein& operator = ( const Levenshtein &other ); /* assignment operator */

		/* ====================  DATA MEMBERS  ======================================= */
	protected:

	private:
	  std::string readFromFile(const std::string fname);

}; /* -----  end of class Levenshtein  ----- */

