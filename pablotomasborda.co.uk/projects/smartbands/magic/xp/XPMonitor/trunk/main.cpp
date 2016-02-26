#include <QtGui>
#include "window.h"
#include <sstream>
#include <cstdlib>
#include <unistd.h>
#include <string>
#include <stdio.h>
#include <iostream>
#include "xpuploader.h"
#include "XPCapture.h"
#include <qthread.h>
#include "XPSeed.h"
#include "login.h"
//#include "moc_login.cpp"
#include <QtGui/QWidget>
#include <QString>

#define UPLOAD_RATE 5
#define TIME_INTERVAL 1

using namespace std;
using namespace Ui;

void *frm_global;

int main(int argc, char *argv[])
{
     QApplication a(argc,argv);
 
     if (!QSystemTrayIcon::isSystemTrayAvailable()) {
         QMessageBox::critical(0, QObject::tr("Systray"),
                               QObject::tr("I couldn't detect any system tray "
                                           "on this system."));
     }

     Window window;
     window.show();



     QWidget logInWidget;



     LogInFrm log_in_dialog;
     log_in_dialog.wnd = &window;
     frm_global = &log_in_dialog;
     log_in_dialog.setupUi(&logInWidget);

     logInWidget.show();




   return a.exec();
}
