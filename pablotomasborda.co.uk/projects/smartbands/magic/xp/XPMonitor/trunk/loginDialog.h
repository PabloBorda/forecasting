/********************************************************************************
** Form generated from reading ui file 'login.ui'
**
** Created: Tue Jun 16 17:30:28 2009
**      by: Qt User Interface Compiler version 4.5.0
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
********************************************************************************/

#ifndef LOGINDIALOG_H
#define LOGINDIALOG_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QLineEdit>
#include <QtGui/QPushButton>
#include <QtGui/QWidget>

QT_BEGIN_NAMESPACE

class Ui_LogInFrm
{
public:
    QLineEdit *lineEdit;
    QLineEdit *lineEdit_2;
    QPushButton *loginbutton;
    QLabel *label;
    QLabel *label_2;

    void setupUi(QWidget *LogInFrm)
    {
        if (LogInFrm->objectName().isEmpty())
            LogInFrm->setObjectName(QString::fromUtf8("LogInFrm"));
        LogInFrm->resize(400, 122);
        lineEdit = new QLineEdit(LogInFrm);
        lineEdit->setObjectName(QString::fromUtf8("lineEdit"));
        lineEdit->setGeometry(QRect(80, 20, 201, 26));
        lineEdit_2 = new QLineEdit(LogInFrm);
        lineEdit_2->setObjectName(QString::fromUtf8("lineEdit_2"));
        lineEdit_2->setGeometry(QRect(80, 50, 201, 26));
        loginbutton = new QPushButton(LogInFrm);
        loginbutton->setObjectName(QString::fromUtf8("loginbutton"));
        loginbutton->setGeometry(QRect(280, 80, 102, 25));
        label = new QLabel(LogInFrm);
        label->setObjectName(QString::fromUtf8("label"));
        label->setGeometry(QRect(10, 30, 56, 16));
        label_2 = new QLabel(LogInFrm);
        label_2->setObjectName(QString::fromUtf8("label_2"));
        label_2->setGeometry(QRect(10, 60, 56, 16));

        retranslateUi(LogInFrm);

        QMetaObject::connectSlotsByName(LogInFrm);
    } // setupUi

    void retranslateUi(QWidget *LogInFrm)
    {
        LogInFrm->setWindowTitle(QApplication::translate("LogInFrm", "Form", 0, QApplication::UnicodeUTF8));
        loginbutton->setText(QApplication::translate("LogInFrm", "Log In", 0, QApplication::UnicodeUTF8));
        label->setText(QApplication::translate("LogInFrm", "Email", 0, QApplication::UnicodeUTF8));
        label_2->setText(QApplication::translate("LogInFrm", "Password", 0, QApplication::UnicodeUTF8));
        Q_UNUSED(LogInFrm);
    } // retranslateUi

};

namespace Ui {
    class LogInFrm: public Ui_LogInFrm {};
} // namespace Ui

QT_END_NAMESPACE

#endif // LOGINDIALOG_H
