#include "xpuploader.h"
#include "xp-commons/UDPClient.h"
#include "xp-commons/ServerRequest.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <iostream>
#include <fstream>
#include "login.h"

#define SERVERPORT "4950"       // the port users will be connecting to
#define SERVERADDR "173.45.224.170"

#include <string>

using namespace std;
using namespace client::udp;
using namespace server;


XPUploader::XPUploader()
{
}

int XPUploader::sendFromFile(string fileName){
    ifstream File(fileName.c_str());
    if ( !File )
    {
        return 0;
    }
    else
    {
        string m_strFileData;
        m_strFileData.reserve( 10000 );
        char Char;
        while ( File.get( Char ) )
        {
            if ( Char != '\n' )
                m_strFileData += Char;
        }
        File.clear();
        File.close();
        return this->sendExperience((char *)m_strFileData.c_str());
    }
}




int XPUploader::sendExperience(char *xp){
    const char *email = ((Ui::LogInFrm *)frm_global)->getUserName();
    printf("The size of the email being sent is %d",strlen(email));
    ServerRequest *sr = new ServerRequest('>',xp,(char *)email);
    UDPClient *c = new UDPClient(SERVERADDR,SERVERPORT);
    c->sendRequest(sr);
    return 0;
}
