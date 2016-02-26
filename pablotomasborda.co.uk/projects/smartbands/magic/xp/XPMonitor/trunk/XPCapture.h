#ifndef XPCAPTURE_H
#define XPCAPTURE_H

#include <qapplication.h>
#include <QObject>
#include <QPixmap>
#include "xpuploader.h"

class XPCapture: public QObject{
 
  public:
    XPCapture();
    ~XPCapture();
    void capture(int shotCounter);
    void setQApplication(QApplication *app);
    QApplication *getQApplication();
  private:
    QApplication *appref;
    long shotCounter;
    long totalShotCounter;
    QPixmap originalPixmap;
};




#endif
