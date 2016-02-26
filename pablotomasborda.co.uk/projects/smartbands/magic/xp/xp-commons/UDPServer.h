#ifndef UDPSERVER_H_
#define UDPSERVER_H_

#include <list>
#include "ServerRequest.h"
#include <sys/types.h>
#include <sys/socket.h>
#include "Session.h"
#include "ServerRequestHandler.h"

using namespace std;
using namespace server::session;


namespace server {
namespace udp {

class UDPServer
{
private:
    int socketID;
    sockaddr *tmp;
    
    long size;
    list<pthread_t> onePerSession;
    bool is_up;
    void login(char *usr,char *passwd);
	void logout(char *usr);
	bool is_server_up();
	const char *port;

public:
  int start();
  int stop();
  
	
  UDPServer();
  UDPServer(const char *port);
  void addRequestType(ServerRequest *req);
  virtual ~UDPServer();
	
protected:
  void request_handler(char *request, char *params[]);
  list<ServerRequest> requests;
  void input(char *);
  ServerRequestHandler *rh;
};
};
};


#endif /*UDPSERVER_H_*/
