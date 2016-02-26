/********************************************************************************
** Form generated from reading ui file 'login.ui'
**
** Created: Tue Jul 7 19:09:01 2009
**      by: Qt User Interface Compiler version 4.5.0
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
********************************************************************************/

#ifndef LOGIN_H
#define LOGIN_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QLineEdit>
#include <QtGui/QPushButton>
#include <QtGui/QWidget>
#include <QObject>
#include <iostream>
#include <QString>
#include "xp-commons/Session.h"
#include "window.h"

class Window;

QT_BEGIN_NAMESPACE

using namespace server::session;

class Ui_LogInFrm: public QObject
{
  Q_OBJECT


protected:
    QString userName;
    QString passwd;

public:
    QLineEdit *lineEdit;
    QLineEdit *lineEdit_2;
    QPushButton *loginbutton;
    QLabel *label;
    QLabel *label_2;
    QWidget *tmp;
    Window *wnd;
   static Session *s;

    void setupUi(QWidget *LogInFrm)
    {
        tmp = LogInFrm;
        if (LogInFrm->objectName().isEmpty())
            LogInFrm->setObjectName(QString::fromUtf8("LogInFrm"));
        LogInFrm->resize(297, 126);
        lineEdit = new QLineEdit(LogInFrm);
        lineEdit->setObjectName(QString::fromUtf8("lineEdit"));
        lineEdit->setGeometry(QRect(80, 20, 201, 26));
        lineEdit_2 = new QLineEdit(LogInFrm);
        lineEdit_2->setObjectName(QString::fromUtf8("lineEdit_2"));
        lineEdit_2->setGeometry(QRect(80, 50, 201, 26));
        loginbutton = new QPushButton(LogInFrm);
        loginbutton->setObjectName(QString::fromUtf8("loginbutton"));
        loginbutton->setGeometry(QRect(180, 80, 102, 25));
        label = new QLabel(LogInFrm);
        label->setObjectName(QString::fromUtf8("label"));
        label->setGeometry(QRect(10, 30, 56, 16));
        label_2 = new QLabel(LogInFrm);
        label_2->setObjectName(QString::fromUtf8("label_2"));
        label_2->setGeometry(QRect(10, 60, 56, 16));

        retranslateUi(LogInFrm);
        QObject::connect(loginbutton, SIGNAL(clicked()), this, SLOT(log_me_in()));

        QMetaObject::connectSlotsByName(LogInFrm);
    } // setupUi

    void retranslateUi(QWidget *LogInFrm)
    {
        LogInFrm->setWindowTitle(QApplication::translate("LogInFrm", "Form", 0, QApplication::UnicodeUTF8));
        loginbutton->setText(QApplication::translate("LogInFrm", "Log In", 0, QApplication::UnicodeUTF8));
        label->setText(QApplication::translate("LogInFrm", "Login", 0, QApplication::UnicodeUTF8));
        label_2->setText(QApplication::translate("LogInFrm", "Password", 0, QApplication::UnicodeUTF8));
        Q_UNUSED(LogInFrm);
    } // retranslateUi

    public slots:

void log_me_in(){
        userName = this->lineEdit->text();
        passwd = this->lineEdit_2->text();
        Session *s = new Session(userName.toStdString(),passwd.toStdString());
        std::cout << "Log In - Clicked " << userName.toStdString();
	wnd->startSeed();
        tmp->close();
      }
 

};

namespace Ui {
    class LogInFrm: public Ui_LogInFrm {
      Q_OBJECT

      public:
        const char *getUserName(){
	  QString tmp = userName;
	  QByteArray ba = tmp.toLatin1();
          return ba.data();
	}
	const char *getPassword(){
          QString tmp = passwd;
	  QByteArray ba = tmp.toLatin1();
	  return ba.data();
	}
   };
} // namespace Ui

QT_END_NAMESPACE

#endif // LOGIN_H
