# ########## Project setup ##########
PROJECT(diffstat)
CMAKE_MINIMUM_REQUIRED(VERSION 2.4.5)

# ######### General setup ##########
INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR})
SET(CMAKE_BUILD_TYPE "Debug")


# ########## diffstat executable ##########
# Sources:
SET(diffstat_executable_SRCS
    hashtable.c
    diffstat.c
)

# Headers:
SET(diffstat_executable_HDRS
    diffstat.h
    hashtable.h
)



# actual target:
ADD_EXECUTABLE(diffstat ${diffstat_executable_SRCS})

# add install target:
INSTALL(TARGETS diffstat DESTINATION bin)
