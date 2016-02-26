#ifndef XPMONITORMASTER_H_
#define XPMONITORMASTER_H_
#define SERVER_PORT 80

#include "xp-commons/UDPServer.h"

using namespace server::udp;

namespace xpmonitor{



class XPMonitorMaster:public server::udp::UDPServer
{
public:
    void setUp();
    int running();
    int halt();
	XPMonitorMaster();
	XPMonitorMaster(char *first_ip_digits);
	virtual ~XPMonitorMaster();
	
private:

    int count;
    int countComputers();
    char *first_ip_digits;
    
};

}

#endif /*XPMONITORMASTER_H_*/
