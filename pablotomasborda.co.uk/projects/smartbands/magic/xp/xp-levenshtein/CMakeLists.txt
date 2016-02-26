# ########## Project setup ##########
PROJECT(xp-levenshtein)
CMAKE_MINIMUM_REQUIRED(VERSION 2.4.5)

# ######### General setup ##########
INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR})

# ########## xp-levenshtein executable ##########
# Sources:
SET(xp-levenshtein_executable_SRCS
    levenstein.cpp
)

LINK_DIRECTORIES(${CMAKE_SOURCE_DIR}/../xp-commons)

# Headers:
SET(xp-levenshtein_executable_HDRS
)

# actual target:
ADD_EXECUTABLE(xp-levenshtein ${xp-levenshtein_executable_SRCS})

TARGET_LINK_LIBRARIES (xp-levenshtein xp-commons)

# add install target:
INSTALL(TARGETS xp-levenshtein DESTINATION bin)
