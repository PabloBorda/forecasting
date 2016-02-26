#include <qdesktopwidget.h>
#include "XPCapture.h"
#include "window.h"
#include <sstream>
#include <cstdlib>
#include <unistd.h>
#include <string>
#include <stdio.h>
#include <iostream>
#include "XPSeed.h"
#include "xp-commons/Utils.h"
#include <qapplication.h>
#define UPLOAD_RATE 1


using namespace std;


XPCapture::XPCapture(){
    shotCounter = 0;
    totalShotCounter = 0;
}

XPCapture::~XPCapture(){
}



void XPCapture::setQApplication(QApplication *app){
  this->appref = app;

}

QApplication *XPCapture::getQApplication(){
  return this->appref;
}

void XPCapture::capture(int shotCounter){
         originalPixmap = QPixmap::grabWindow(QApplication::desktop()->winId());
         originalPixmap.save(("ptbdbtmp-" + strFromInt(shotCounter) + ".tmp").c_str(),"jpeg",100);
         std::cout << launch(("djpeg -pnm -gray ptbdbtmp-" + strFromInt(shotCounter) + ".tmp | ./core -o ptbdbtmp-text-" + strFromInt(shotCounter) + ".tmp").c_str()) << endl;

}       



