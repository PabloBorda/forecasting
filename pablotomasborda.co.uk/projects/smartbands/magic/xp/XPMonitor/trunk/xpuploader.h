#ifndef XPUPLOADER_H
#define XPUPLOADER_H

#include <string>
#include "window.h"

using namespace std;

extern void *frm_global;

class XPUploader
{
public:
    XPUploader();
    int sendExperience(char *xp);
    int sendFromFile(string fileName);


};

#endif // XPUPLOADER_H
