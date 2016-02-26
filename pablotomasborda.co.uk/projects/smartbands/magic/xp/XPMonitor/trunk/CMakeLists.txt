# ########## Project setup ##########
PROJECT(XPMonitor)
CMAKE_MINIMUM_REQUIRED(VERSION 2.4.5)

# ########## Qt4 setup ##########
FIND_PACKAGE(Qt4 REQUIRED)
INCLUDE(${QT_USE_FILE})
INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR} ${QT_INCLUDES})
SET(CMAKE_BUILD_TYPE "Debug")


# ########## XPMonitor executable ##########
# Sources:
SET(XPMonitor_executable_SRCS
    window.cpp
    xpuploader.cpp
    main.cpp
    moc_window.cpp
    qrc_systray.cpp
    XPCapture.cpp
    XPSeed.cpp
    moc_XPSeed.cpp
    moc_login.cpp
    systray.qrc
)

# Headers:
SET(XPMonitor_executable_HDRS
    xpuploader.h
    window.h
    XPCapture.h
    XPSeed.h
    login.h
)

# UI files:
#SET(XPMonitor_executable_UIS
#    xpmonitor.ui
#)


# scan files and run moc on all that need it:
QT4_AUTOMOC(${XPMonitor_executable_SRCS})
LINK_DIRECTORIES(${CMAKE_SOURCE_DIR}/xp-commons)



# actual target:
ADD_EXECUTABLE(XPMonitor ${XPMonitor_executable_SRCS})
TARGET_LINK_LIBRARIES(XPMonitor ${QT_LIBRARIES} xp-commons)

# add install target:
INSTALL(TARGETS XPMonitor DESTINATION bin)
