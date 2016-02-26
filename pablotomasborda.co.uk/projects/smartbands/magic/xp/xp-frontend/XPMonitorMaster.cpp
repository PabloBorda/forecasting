#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdio.h>
#include <netdb.h>
#include <stdlib.h>

#include "XPMonitorMaster.h"
#include "xp-commons/UDPServer.h"
#include "xp-commons/ServerRequest.h"
#include "xp-commons/ServerRequestHandler.h"
#include "XPTargetServerRequest.h"



using namespace xpmonitor;
using namespace std;
using namespace server::udp;
using namespace server;
using namespace request;

XPMonitorMaster::XPMonitorMaster(): UDPServer()
{
  XPTargetServerRequest *shoot = new XPTargetServerRequest();
  shoot->setRequestID('>');
  rh->mapRequest(shoot);

 
  

}

XPMonitorMaster::XPMonitorMaster(char *first_ip_digits): UDPServer()
{
	this->first_ip_digits = first_ip_digits;
	
}


XPMonitorMaster::~XPMonitorMaster()
{
}

void XPMonitorMaster::setUp()
{
   this->start();	
}
