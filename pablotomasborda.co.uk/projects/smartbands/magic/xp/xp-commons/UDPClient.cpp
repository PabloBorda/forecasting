#include "UDPClient.h"
#include "ServerRequest.h"
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
#include <string>
#include "commons.h"


#define SERVERADDR "173.45.224.170"
#define SERVERPORT "4950"


using namespace std;
using namespace client::udp;
using namespace server;


UDPClient::UDPClient(){

}



UDPClient::UDPClient(char *ip,char *port){
  this->ip = ip;
  this->port = port;
}


UDPClient::~UDPClient(){

}


bool UDPClient::sendData(char *data){
    int sockfd;
    struct addrinfo hints, *servinfo, *p;
    int rv;
    int numbytes;

    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_DGRAM;

    if ((rv = getaddrinfo(this->ip,this->port, &hints, &servinfo)) != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv));
        return 1;
    }

    // loop through all the results and make a socket
    for(p = servinfo; p != NULL; p = p->ai_next) {
        if ((sockfd = socket(p->ai_family, p->ai_socktype,
                             p->ai_protocol)) == -1) {
            perror("talker: socket");
            continue;
        }

        break;
    }

    if (p == NULL) {
        fprintf(stderr, "talker: failed to bind socket\n");
        return 2;
    }

    if ((numbytes = sendto(sockfd,data, strlen(data), 0,p->ai_addr, p->ai_addrlen)) == -1) {
        perror("talker: sendto");
        exit(1);
    }

    freeaddrinfo(servinfo);

    printf("talker: sent %d bytes to %s\n", numbytes,SERVERADDR);
    close(sockfd);

    return 0;
}


bool UDPClient::sendRequest(ServerRequest *req){
    int sockfd;
    struct addrinfo hints, *servinfo, *p;
    int rv;
    int numbytes;

    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_DGRAM;

    if ((rv = getaddrinfo(this->ip,this->port, &hints, &servinfo)) != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv));
        return 1;
    }

    // loop through all the results and make a socket
    for(p = servinfo; p != NULL; p = p->ai_next) {
        if ((sockfd = socket(p->ai_family, p->ai_socktype,
                             p->ai_protocol)) == -1) {
            perror("talker: socket");
            continue;
        }

        break;
    }

    if (p == NULL) {
        fprintf(stderr, "talker: failed to bind socket\n");
        return 2;
    }
    char reqid_tmp = (req->getRequestID());
    if ((numbytes = sendto(sockfd,&reqid_tmp,sizeof(char), 0,p->ai_addr, p->ai_addrlen)) == -1) {
        perror("Error sending instruction code");
        exit(1);
    }

    int email_size = strlen(req->getEmail());   
    printf("We are sending email size: %d",email_size);
    if ((numbytes = sendto(sockfd,&email_size,sizeof(int), 0,p->ai_addr, p->ai_addrlen)) == -1) {
        perror("Error sending email size");
        exit(1);
    }
 
    if ((numbytes = sendto(sockfd,req->getEmail(),strlen(req->getEmail()), 0,p->ai_addr, p->ai_addrlen)) == -1) {
        perror("Error sending email");
        exit(1);
    }

    long cs = checksum(req->getEmail());
    printf("I'm sending the %ld hash code",cs); 
    if ((numbytes = sendto(sockfd,&cs,sizeof(long), 0,p->ai_addr, p->ai_addrlen)) == -1) {
        perror("Error sending email hash code");
        exit(1);
    }


    if ((numbytes = sendto(sockfd,req->getArgs(),strlen(req->getArgs()), 0,p->ai_addr, p->ai_addrlen)) == -1) {
        perror("Error sending shot");
        exit(1);
    }

    freeaddrinfo(servinfo);

    printf("talker: sent %d bytes to %s\n", numbytes,SERVERADDR);
    close(sockfd);

    return 0;
}

