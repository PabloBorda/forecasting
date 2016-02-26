#include <iostream>
#include "XPMonitorMaster.h"

using namespace std;
using namespace xpmonitor;

int main()
{
	
    XPMonitorMaster *master = new XPMonitorMaster((char *)"192.168.0");
    master->setUp();
	
    cout << "Hello World!";
    return 0;
}
