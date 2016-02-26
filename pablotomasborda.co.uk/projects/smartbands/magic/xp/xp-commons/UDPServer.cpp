#include "UDPServer.h"
#include <pthread.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdio.h>
#include <netdb.h>
#include <cstdlib>
#include <string.h>
#include <list>
#include "ServerRequestHandler.h"
#include "commons.h"

using namespace std;
using namespace server::udp;

UDPServer::UDPServer()
{
	this->is_up = false;
	this->socketID = socket(AF_INET,SOCK_DGRAM,0);
	this->port = "4950";
        this->rh = new ServerRequestHandler();
	
}

UDPServer::UDPServer(const char *port){
  this->port = port;	
}

UDPServer::~UDPServer()
{
}


int UDPServer::start(){
    this->is_up = true;
   
    struct addrinfo hints, *servinfo, *p;
    int rv;
    int numbytes;
    struct sockaddr_storage their_addr;
    socklen_t addr_len;
    char s[INET6_ADDRSTRLEN];

    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_INET; // set to AF_INET to force IPv4
    hints.ai_socktype = SOCK_DGRAM;
    hints.ai_flags = AI_PASSIVE; // use my IP

    if ((rv = getaddrinfo(NULL,this->port, &hints, &servinfo)) != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv));
        return 1;
    }
	
	 // loop through all the results and bind to the first we can
    for(p = servinfo; p != NULL; p = p->ai_next) {
        if ((this->socketID = socket(p->ai_family, p->ai_socktype,
                p->ai_protocol)) == -1) {
            perror("listener: socket");
            continue;
        }

        if (bind(this->socketID, p->ai_addr, p->ai_addrlen) == -1) {
            close(this->socketID);
            perror("listener: bind");
            continue;
        }

        break;
    }
    
    if (p == NULL) {
        fprintf(stderr, "listener: failed to bind socket\n");
        return 2;
    }
	
    freeaddrinfo(servinfo);
    addr_len = sizeof their_addr;


    printf("listener: waiting for shots...\n");
    	
	char buffer = 'x';
       long cs = 0;

	if ((numbytes = recvfrom(this->socketID, &buffer, 1 , 0,(struct sockaddr *)&their_addr, &addr_len)) == -1) {
          perror("Error getting instruction code");
          exit(1);
        }
        while (buffer != 'q'){
          char *params = (char *)malloc(20000);
          char *mail = (char *)malloc(350);
          int email_size;
	  if ((numbytes = recvfrom(this->socketID, &email_size, sizeof(int) , 0,(struct sockaddr *)&their_addr, &addr_len)) == -1) {
            perror("Error getting email size\n");
            exit(1);
          } 
          printf("Im receiving email size: %d\n",email_size); 
	  if ((numbytes = recvfrom(this->socketID, mail, email_size , 0,(struct sockaddr *)&their_addr, &addr_len)) == -1) {
            perror("Error getting email");
            exit(1);
          } 
          
          if ((numbytes = recvfrom(this->socketID, &cs, sizeof(long) , 0,(struct sockaddr *)&their_addr, &addr_len)) == -1) {
	    perror("Error getting email hash code\n");
	    exit(1);
	  }
          
          long val = checksum(mail);
          bool wrong_email = false;
          if (cs != val){
            printf("The email address I got is wrong, I got hash %ld and I expected to get hash %ld\n",cs,val);
            wrong_email = true;
          }

	  if ((numbytes = recvfrom(this->socketID, params, 20000 , 0,(struct sockaddr *)&their_addr, &addr_len)) == -1) {
            perror("Error getting shot\n");
            exit(1);
          }
          params[strlen(params)] = '\0';
//          printf("I got %s bytes as argument\n",params);
          if (numbytes > 0) {
            if (wrong_email == false) {
              rh->doAction(buffer,params,mail);
            } else {
              rh->doAction(buffer,params,NULL);
            }
          }
           else {
             printf("This request %s has no arguments\n", &buffer);
           }
   
          if ((numbytes = recvfrom(this->socketID, &buffer, 1 , 0,(struct sockaddr *)&their_addr, &addr_len)) == -1) {
            perror("Error getting instruction code\n");
            exit(1);
          } 
 	free(mail);
	free(params);
	      
        }
        printf("Stopping server ...\n");
        printf("Stopped.");

}


void UDPServer::addRequestType(ServerRequest *req){
  requests.push_back(*req);
}
