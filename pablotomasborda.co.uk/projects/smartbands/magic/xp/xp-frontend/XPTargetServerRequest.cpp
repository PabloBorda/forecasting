#include "xp-commons/ServerRequest.h"
#include "XPTargetServerRequest.h"
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <time.h>
#include <cstring>
#include <string.h>
#include "xp-commons/Utils.h"
#include <sys/stat.h>
#include <sys/time.h>

using namespace request;
using namespace std;

XPTargetServerRequest::XPTargetServerRequest():ServerRequest(){

}

XPTargetServerRequest::~XPTargetServerRequest(){

}


int fileExists(char *fileName){
  struct stat buffer;
  if (stat(fileName,&buffer)){
    return 1;
  }
  return 0;
}



void insertToFileSystem(char *mail,char *args){
  char cmd[500] = "mkdir shots/"; 
  launch(strcat(cmd,mail)); 
  

  ofstream toFile;
  time_t secs;
  secs = time(NULL);

  struct timeval detail_time;  
  gettimeofday(&detail_time,NULL);  
  


    
  char relPath[500] = "shots/";
  strcat(relPath,mail);
  strcat(relPath,"/");  

  char fileName[150];
  
  sprintf(fileName,"shot_%ld%ld.txt",secs,detail_time.tv_usec);

  strcat(relPath,fileName);

  toFile.open(relPath);
  toFile << args;
  toFile.close();
   
}


int ServerRequest::execute(){
  cout << "===============================================================================================================";
  cout << "I got your email: " << this->getEmail() << "\n";
  cout << "I got your experience: " << this->getArgs() << "\n";
  cout << "==============================================================================================================="; 
  insertToFileSystem(this->getEmail(),this->getArgs());
}

