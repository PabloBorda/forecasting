#include "ServerRequestHandler.h"
#include "ServerRequest.h"

using namespace server;
using std::pair;
using std::make_pair;


ServerRequestHandler::ServerRequestHandler()
{
}

ServerRequestHandler::~ServerRequestHandler()
{
}

void ServerRequestHandler::mapRequest(ServerRequest *requestObject){
        char tmp = requestObject->getRequestID();
        this->request_mapper.insert(make_pair(tmp,*requestObject));
}


char *ServerRequestHandler::doAction(char requestStr,char *args,char *email){
      if (email != NULL){
 	ServerRequest *req;
	req = &(this->request_mapper[requestStr]);
        req->setEmail(email);
        req->setArgs(args);
	req->exec();
	return req->getOutput();
      } else 
          return NULL;
}
