/****************************************************************************
** Meta object code from reading C++ file 'XPSeed.h'
**
** Created: Mon Jun 15 17:38:58 2009
**      by: The Qt Meta Object Compiler version 61 (Qt 4.5.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "XPSeed.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'XPSeed.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 61
#error "This file was generated using the moc from 4.5.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_XPSeed[] = {

 // content:
       2,       // revision
       0,       // classname
       0,    0, // classinfo
       2,   12, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors

 // signals: signature, parameters, type, tag, flags
      20,    8,    7,    7, 0x05,
      38,    8,    7,    7, 0x05,

       0        // eod
};

static const char qt_meta_stringdata_XPSeed[] = {
    "XPSeed\0\0shotCounter\0changedValue(int)\0"
    "sendTheInfoNow(int)\0"
};

const QMetaObject XPSeed::staticMetaObject = {
    { &QThread::staticMetaObject, qt_meta_stringdata_XPSeed,
      qt_meta_data_XPSeed, 0 }
};

const QMetaObject *XPSeed::metaObject() const
{
    return &staticMetaObject;
}

void *XPSeed::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_XPSeed))
        return static_cast<void*>(const_cast< XPSeed*>(this));
    return QThread::qt_metacast(_clname);
}

int XPSeed::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QThread::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: changedValue((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 1: sendTheInfoNow((*reinterpret_cast< int(*)>(_a[1]))); break;
        default: ;
        }
        _id -= 2;
    }
    return _id;
}

// SIGNAL 0
void XPSeed::changedValue(int _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void XPSeed::sendTheInfoNow(int _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}
QT_END_MOC_NAMESPACE
