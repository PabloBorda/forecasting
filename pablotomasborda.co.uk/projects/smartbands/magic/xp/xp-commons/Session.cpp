#include "Session.h"

#include <string>

using namespace server::session;

Session::Session(string email, string passwd){
  this->email = email;
  this->passwd = passwd;

}


Session::~Session(){

}


bool Session::authenticate(){
  return true;
}



