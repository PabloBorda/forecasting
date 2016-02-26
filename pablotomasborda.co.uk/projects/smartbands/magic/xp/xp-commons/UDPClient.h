#ifndef UDPCLIENT_H
#define UDPCLIENT_H

#include <string>
#include "ServerRequest.h"

using namespace std;
using namespace server;


namespace client{
  namespace udp{
    class UDPClient{
     
      public:
        UDPClient();
        UDPClient(char *ip,char *port);
        bool sendData(char *data);
        bool sendRequest(ServerRequest *req);
        ~UDPClient();
      private:
        char *ip;
        char *port;

    };
  };
};

#endif
