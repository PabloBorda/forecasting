#include "XPSeed.h"
#include "XPCapture.h"
#include "xpuploader.h"



XPSeed::XPSeed(int interval, int send_every){
  this->interval = interval;
  this->send_every_shots = send_every;
}

XPSeed::~XPSeed(){
}

void XPSeed::valuePlusOne(){
  val = val + 1;
  emit changedValue(val);
}

void XPSeed::run(){
  while (interval != -1){
    while (val < send_every_shots){
      wait(interval);
      valuePlusOne();
    }
    if (val >= send_every_shots){
      emit sendTheInfoNow(val);
      val = 0;
    }
  }
}

void XPSeed::stop(){
  this->interval = -1;
  this->val = 0;
}

int XPSeed::getVal(){
  return this->val;
}


void XPSeed::wait(int seconds){
   clock_t start_time, cur_time;
   start_time = clock();
   while((clock() - start_time) < seconds * CLOCKS_PER_SEC)
   {
   }
}



