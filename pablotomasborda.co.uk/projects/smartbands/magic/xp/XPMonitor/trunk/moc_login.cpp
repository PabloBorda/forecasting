/****************************************************************************
** Meta object code from reading C++ file 'login.h'
**
** Created: Thu Aug 27 13:20:14 2009
**      by: The Qt Meta Object Compiler version 61 (Qt 4.5.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "login.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'login.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 61
#error "This file was generated using the moc from 4.5.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_Ui_LogInFrm[] = {

 // content:
       2,       // revision
       0,       // classname
       0,    0, // classinfo
       1,   12, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors

 // slots: signature, parameters, type, tag, flags
      13,   12,   12,   12, 0x0a,

       0        // eod
};

static const char qt_meta_stringdata_Ui_LogInFrm[] = {
    "Ui_LogInFrm\0\0log_me_in()\0"
};

const QMetaObject Ui_LogInFrm::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_Ui_LogInFrm,
      qt_meta_data_Ui_LogInFrm, 0 }
};

const QMetaObject *Ui_LogInFrm::metaObject() const
{
    return &staticMetaObject;
}

void *Ui_LogInFrm::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_Ui_LogInFrm))
        return static_cast<void*>(const_cast< Ui_LogInFrm*>(this));
    return QObject::qt_metacast(_clname);
}

int Ui_LogInFrm::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: log_me_in(); break;
        default: ;
        }
        _id -= 1;
    }
    return _id;
}
static const uint qt_meta_data_Ui__LogInFrm[] = {

 // content:
       2,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors

       0        // eod
};

static const char qt_meta_stringdata_Ui__LogInFrm[] = {
    "Ui::LogInFrm\0"
};

const QMetaObject Ui::LogInFrm::staticMetaObject = {
    { &Ui_LogInFrm::staticMetaObject, qt_meta_stringdata_Ui__LogInFrm,
      qt_meta_data_Ui__LogInFrm, 0 }
};

const QMetaObject *Ui::LogInFrm::metaObject() const
{
    return &staticMetaObject;
}

void *Ui::LogInFrm::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_Ui__LogInFrm))
        return static_cast<void*>(const_cast< LogInFrm*>(this));
    return Ui_LogInFrm::qt_metacast(_clname);
}

int Ui::LogInFrm::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = Ui_LogInFrm::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    return _id;
}
QT_END_MOC_NAMESPACE
