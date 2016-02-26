# ########## Project setup ##########
PROJECT(xp-frontend)
CMAKE_MINIMUM_REQUIRED(VERSION 2.4.5)

# ######### General setup ##########
INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR})

SET(CMAKE_BUILD_TYPE "Debug")

# ########## xp-frontend executable ##########
# Sources:
SET(xp-frontend_executable_SRCS
    XPMonitorMaster.cpp
    XPTargetServerRequest.cpp
    main.cpp
)

# Headers:
SET(xp-frontend_executable_HDRS
    XPMonitorMaster.h
    XPTargetServerRequest.h
)

LINK_DIRECTORIES(${CMAKE_SOURCE_DIR}/xp-commons)
# actual target:
ADD_EXECUTABLE(xp-frontend ${xp-frontend_executable_SRCS})
TARGET_LINK_LIBRARIES (xp-frontend xp-commons) 

# add install target:
INSTALL(TARGETS xp-frontend DESTINATION bin)
