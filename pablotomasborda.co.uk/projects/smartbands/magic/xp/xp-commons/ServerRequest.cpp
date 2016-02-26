#include "ServerRequest.h"
#include <typeinfo>
#include <iostream>
#include <iostream>
#include <stdlib.h>

using namespace server;
using namespace std;

ServerRequest::ServerRequest()
{
  this->req_id = NULL;
  this->args = NULL;
  this->email = NULL;

}

ServerRequest::ServerRequest(char req_id,char *args,char *email){
  this->req_id = req_id;
  this->args = args;
  this->email = email;
}


ServerRequest::~ServerRequest()
{
}

bool ServerRequest::before(){
  return true;
}

bool ServerRequest::after(){
  return true;
}

char *ServerRequest::getOutput(){
	return this->output;
}

void ServerRequest::setOutput(char *o){
  this->output = o;	
}

int ServerRequest::execute(){
  return 0;
}


/*int ServerRequest::execute(){

  char user[320];
  int retval = 0;

  char *sumFromArgs = (char *)malloc(sizeof(long));
  for (int j=0; j < sizeof(long);j++){
    sumFromArgs[j] = this->args[320+j];
  }
  long sumFromArgsLong = (long)sumFromArgs;  


  long checksum = 0; 
  if (args != NULL){
    int i;
    for (i=0;i<320;i++){
      user[i] = this->args[i];
      checksum = checksum + user[i];
    } 
    user[i] = '\0';
    if (checksum == sumFromArgsLong){
      cout << "Request is Ok, processing";
     return 0;
    } else {
        cout << "Request failed";
        return 1;
      }
  }
  return 1;
  return 1;
}*/

bool ServerRequest::exec() {
   if (this->before()){
     this->execute();
     return this->after();
   } else {
   	 std::cout << typeid(this).name()  << std::endl;
   	 return false;
   }
}

char ServerRequest::getRequestID(){
  return this->req_id;
}

void ServerRequest::setRequestID(char req_id){
  this->req_id = req_id;
}

char *ServerRequest::getArgs(){
  return this->args;
}

char *ServerRequest::getEmail(){
  return this->email;
}

void ServerRequest::setEmail(char *mail){
  this->email = mail;
}

void ServerRequest::setArgs(char *args){
  this->args = args;
}


