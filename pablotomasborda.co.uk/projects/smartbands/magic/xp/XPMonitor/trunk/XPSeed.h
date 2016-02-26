#ifndef XPSEED_H
#define XPSEED_H
#include <QThread>
#include "XPCapture.h"

class XPSeed : public QThread{

 Q_OBJECT

 signals:
    void changedValue(int shotCounter);
    void sendTheInfoNow(int shotCounter);
 private:
    int val;
    int interval;
    int send_every_shots;
//    void wait(int seconds);
 public:
    XPSeed(int interval, int send_every);
    ~XPSeed();
    virtual void run();
    virtual void stop();
    int getVal();
    void valuePlusOne();
    void wait(int seconds);
 
};
#endif

