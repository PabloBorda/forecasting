#ifndef XPSESSION_H
#define XPSESSION_H

#include <string>
#include <iostream>

using namespace std;

namespace server{
  namespace session{

    class Session {
      public:
        string email;
        string passwd;
        Session(string email, string passwd);
        ~Session();
        bool authenticate();        
    }; 

  };
};

#endif
