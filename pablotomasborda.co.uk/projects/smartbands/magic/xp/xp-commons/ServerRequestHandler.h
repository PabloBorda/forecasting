#ifndef UDPREQUESTHANDLER_H_
#define UDPREQUESTHANDLER_H_
#include <map>
#include <string.h>
#include "ServerRequest.h"

using namespace std;

namespace server{

class ServerRequestHandler
{
private:
  map<char,ServerRequest> request_mapper;

public:
    void mapRequest(ServerRequest *requestObject);
    char *doAction(char requestStr,char *email,char *args); 
    ServerRequestHandler();
    virtual ~ServerRequestHandler();
};
};
#endif /*UDPREQUESTHANDLER_H_*/
