/****************************************************************************
 **
 ** Copyright (C) 2006-2007 Trolltech ASA. All rights reserved.
 **
 ** This file is part of the example classes of the Qt Toolkit.
 **
 ** This file may be used under the terms of the GNU General Public
 ** License version 2.0 as published by the Free Software Foundation
 ** and appearing in the file LICENSE.GPL included in the packaging of
 ** this file.  Please review the following information to ensure GNU
 ** General Public Licensing requirements will be met:
 ** http://www.trolltech.com/products/qt/opensource.html
 **
 ** If you are unsure which license is appropriate for your use, please
 ** review the following information:
 ** http://www.trolltech.com/products/qt/licensing.html or contact the
 ** sales department at sales@trolltech.com.
 **
 ** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
 ** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 **
 ****************************************************************************/

 #include <QtGui>
 #include <sstream>
 #include <iostream>

 #include "window.h"
 #include "XPSeed.h"
 #include "XPCapture.h"
 #include "xp-commons/Utils.h"
 #include "xpuploader.h"


 #define TIME_INTERVAL 240
 #define SEND_EVERY 5


 Window::Window()
 {
     //createIconGroupBox();
     createMessageGroupBox();


     createActions();
     createTrayIcon();

     //connect(showMessageButton, SIGNAL(clicked()), this, SLOT(showMessage()));
     //connect(showIconCheckBox, SIGNAL(toggled(bool)),
     //        trayIcon, SLOT(setVisible(bool)));
     //connect(iconComboBox, SIGNAL(currentIndexChanged(int)),
     //        this, SLOT(setIcon(int)));
     connect(trayIcon, SIGNAL(messageClicked()), this, SLOT(messageClicked()));
     connect(trayIcon, SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
             this, SLOT(iconActivated(QSystemTrayIcon::ActivationReason)));

     QVBoxLayout *mainLayout = new QVBoxLayout;
     //mainLayout->addWidget(iconGroupBox);
     //mainLayout->addWidget(messageGroupBox);
     setLayout(mainLayout);

     //iconComboBox->setCurrentIndex(1);
     trayIcon->show();

     setWindowTitle(tr("Experience Monitor"));
     resize(400, 300);

 
 }

 void Window::setVisible(bool visible)
 {
     minimizeAction->setEnabled(visible);
     maximizeAction->setEnabled(!isMaximized());
     restoreAction->setEnabled(isMaximized() || !visible);
     QWidget::setVisible(visible);
 }

 void Window::closeEvent(QCloseEvent *event)
 {
     if (trayIcon->isVisible()) {
         QMessageBox::information(this, tr("Systray"),
                                  tr("The program will keep running in the "
                                     "system tray. To terminate the program, "
                                     "choose <b>Quit</b> in the context menu "
                                     "that pops up when clicking this program's "
                                     "entry in the system tray."));
         hide();
         event->ignore();
     }
 }

 void Window::setIcon(int index)
 {
     QString fileName = "rrhh.gif";
     QIcon *icon = new QIcon(fileName);// iconComboBox->itemIcon(index);
     trayIcon->setIcon(*icon);
     setWindowIcon(*icon);

     //trayIcon->setToolTip(iconComboBox->itemText(index));
 }

 void Window::iconActivated(QSystemTrayIcon::ActivationReason reason)
 {
     switch (reason) {
     case QSystemTrayIcon::Trigger:
     case QSystemTrayIcon::DoubleClick:
         //iconComboBox->setCurrentIndex((iconComboBox->currentIndex() + 1)
         //                              % iconComboBox->count());
         break;
     case QSystemTrayIcon::MiddleClick:
         showMessage();
         break;
     default:
         ;
     }
 }

 void Window::showMessage()
 {
    /* QSystemTrayIcon::MessageIcon icon = QSystemTrayIcon::MessageIcon(
             typeComboBox->itemData(typeComboBox->currentIndex()).toInt());
     trayIcon->showMessage(titleEdit->text(), bodyEdit->toPlainText(), icon,
                           durationSpinBox->value() * 1000);*/
 }

 void Window::messageClicked()
 {
     QMessageBox::information(0, tr("Systray"),
                              tr("Sorry, I already gave what help I could.\n"
                                 "Maybe you should try asking a human?"));
 }



 void Window::createMessageGroupBox()
 {

 }

 void Window::createActions()
 {
     minimizeAction = new QAction(tr("Mi&nimize"), this);
     connect(minimizeAction, SIGNAL(triggered()), this, SLOT(hide()));

     maximizeAction = new QAction(tr("Ma&ximize"), this);
     connect(maximizeAction, SIGNAL(triggered()), this, SLOT(showMaximized()));

     restoreAction = new QAction(tr("&Restore"), this);
     connect(restoreAction, SIGNAL(triggered()), this, SLOT(showNormal()));

     quitAction = new QAction(tr("&Quit"), this);
     connect(quitAction, SIGNAL(triggered()), qApp, SLOT(quit()));
    
     shooter = new XPCapture();
     seed = new XPSeed(5,1);
     connect(seed,SIGNAL(changedValue(int)),this,SLOT(screenCapture(int)));
     connect(seed,SIGNAL(sendTheInfoNow(int)),this,SLOT(sendTheInfoNow(int)));
 

 }

 void Window::createTrayIcon()
 {
     trayIconMenu = new QMenu(this);
     trayIconMenu->addAction(minimizeAction);
     trayIconMenu->addAction(maximizeAction);
     trayIconMenu->addAction(restoreAction);
     trayIconMenu->addSeparator();
     trayIconMenu->addAction(quitAction);

     trayIcon = new QSystemTrayIcon(this);
     trayIcon->setContextMenu(trayIconMenu);
     this->setIcon(1);
 }

void Window::screenCapture(int shotCounter){
  shooter->capture(shotCounter);

}

void Window::startSeed(){
  seed->start();


}


  void Window::sendTheInfoNow(int shotCounter){
    XPUploader *xpu = new XPUploader();
    for (long i=0;i<=shotCounter;i++){
      xpu->sendFromFile("ptbdbtmp-text-" + strFromInt(i) + ".tmp");
    }
    launch("rm *.tmp");
  }


