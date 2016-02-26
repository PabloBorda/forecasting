/********************************************************************************
** Form generated from reading ui file 'xpmonitor.ui'
**
** Created: Mon Jun 8 14:02:29 2009
**      by: Qt User Interface Compiler version 4.5.1
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
********************************************************************************/

#ifndef UI_XPMONITOR_H
#define UI_XPMONITOR_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QDialog>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QPushButton>
#include <QtGui/QSpinBox>

QT_BEGIN_NAMESPACE

class Ui_XPMonitor
{
public:
    QLabel *label;
    QLabel *label_2;
    QSpinBox *spinBox;
    QLabel *label_3;
    QPushButton *pushButton;
    QPushButton *pushButton_2;

    void setupUi(QDialog *XPMonitor)
    {
        if (XPMonitor->objectName().isEmpty())
            XPMonitor->setObjectName(QString::fromUtf8("XPMonitor"));
        XPMonitor->resize(456, 212);
        QIcon icon;
        icon.addPixmap(QPixmap(QString::fromUtf8("xpmonitor.jpeg")), QIcon::Normal, QIcon::Off);
        XPMonitor->setWindowIcon(icon);
        label = new QLabel(XPMonitor);
        label->setObjectName(QString::fromUtf8("label"));
        label->setGeometry(QRect(40, 50, 141, 16));
        label_2 = new QLabel(XPMonitor);
        label_2->setObjectName(QString::fromUtf8("label_2"));
        label_2->setGeometry(QRect(240, 50, 56, 16));
        spinBox = new QSpinBox(XPMonitor);
        spinBox->setObjectName(QString::fromUtf8("spinBox"));
        spinBox->setGeometry(QRect(180, 40, 58, 26));
        label_3 = new QLabel(XPMonitor);
        label_3->setObjectName(QString::fromUtf8("label_3"));
        label_3->setGeometry(QRect(300, 50, 121, 16));
        pushButton = new QPushButton(XPMonitor);
        pushButton->setObjectName(QString::fromUtf8("pushButton"));
        pushButton->setGeometry(QRect(230, 170, 102, 25));
        pushButton_2 = new QPushButton(XPMonitor);
        pushButton_2->setObjectName(QString::fromUtf8("pushButton_2"));
        pushButton_2->setGeometry(QRect(340, 170, 102, 25));

        retranslateUi(XPMonitor);

        QMetaObject::connectSlotsByName(XPMonitor);
    } // setupUi

    void retranslateUi(QDialog *XPMonitor)
    {
        XPMonitor->setWindowTitle(QApplication::translate("XPMonitor", "XPMonitor", 0, QApplication::UnicodeUTF8));
        label->setText(QApplication::translate("XPMonitor", "Set shot time interval:", 0, QApplication::UnicodeUTF8));
        label_2->setText(QApplication::translate("XPMonitor", "seconds", 0, QApplication::UnicodeUTF8));
        label_3->setText(QApplication::translate("XPMonitor", "(Default 5 seconds)", 0, QApplication::UnicodeUTF8));
        pushButton->setText(QApplication::translate("XPMonitor", "Save", 0, QApplication::UnicodeUTF8));
        pushButton_2->setText(QApplication::translate("XPMonitor", "Cancel", 0, QApplication::UnicodeUTF8));
        Q_UNUSED(XPMonitor);
    } // retranslateUi

};

namespace Ui {
    class XPMonitor: public Ui_XPMonitor {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_XPMONITOR_H
