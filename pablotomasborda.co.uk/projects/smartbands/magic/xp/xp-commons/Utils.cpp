#include "Utils.h"
#include <iostream>
#include <sstream>
#include <cstdlib>
#include <unistd.h>
#include <string>
#include <stdio.h>
#include <iostream>


string launch(const char *command){
   FILE *fpipe;
   char line[2048];
   string ou = "";

   if ( !(fpipe = (FILE*)popen(command,"r")) )
   {  // If fpipe is NULL
      perror("Problems with pipe");
      exit(1);
   }

   while ( fgets( line, sizeof line, fpipe))
   {
     ou.append(line);
   }
   pclose(fpipe);
   return ou;
}

std::string strFromInt(long x){
    std::ostringstream stm;
    stm << x;
    return stm.str();
}


