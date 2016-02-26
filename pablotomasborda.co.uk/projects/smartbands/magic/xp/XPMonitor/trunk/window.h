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

 #ifndef WINDOW_H
 #define WINDOW_H

 #include <QSystemTrayIcon>
 #include <QWidget>
 #include "XPCapture.h"
 #include "XPSeed.h"



 class QAction;
 class QCheckBox;
 class QComboBox;
 class QGroupBox;
 class QLabel;
 class QLineEdit;
 class QMenu;
 class QPushButton;
 class QSpinBox;
 class QTextEdit;
 class XPCapture;
 class XPSeed;


 class Window : public QWidget
 {
     Q_OBJECT

 public:
     Window();
     XPSeed *seed;
     void setVisible(bool visible);
     void startSeed();

 protected:
     void closeEvent(QCloseEvent *event);

 private slots:
     void setIcon(int index);
     void iconActivated(QSystemTrayIcon::ActivationReason reason);
     void showMessage();
     void messageClicked();
     void screenCapture(int shotCounter);
     void sendTheInfoNow(int shotCounter);
 private:
     void createIconGroupBox();
     void createMessageGroupBox();
     void createActions();
     void createTrayIcon();

     XPCapture *shooter;
     QComboBox *iconComboBox;

     QAction *minimizeAction;
     QAction *maximizeAction;
     QAction *restoreAction;
     QAction *quitAction;

     QSystemTrayIcon *trayIcon;
     QMenu *trayIconMenu;
     QLineEdit *username;
     QLineEdit *passwd;
 };

 #endif
