# ########## Project setup ##########
PROJECT(xp-commons)
CMAKE_MINIMUM_REQUIRED(VERSION 2.4.5)

# ######### General setup ##########
INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR})

SET(CMAKE_BUILD_TYPE "Debug")


# ########## xp-commons library ##########
# Sources::
SET(xp-commons_library
    UDPServer.cpp
    UDPClient.cpp
    ServerRequest.cpp
    tcpserver.cpp
    ServerRequestHandler.cpp
    Utils.cpp
    Session.cpp
    commons.cpp
    HashStaticRecord.cpp
    HashRecord.cpp
    DynamicHashTable.cpp
    Bucket.cpp
    levenshtein.cpp
    UDPServer.h
    UDPClient.h
    ServerRequestHandler.h
    tcpserver.h
    ServerRequest.h
    Utils.h
    Session.h
    commons.h
    HashRecord.h
    HashStaticRecord.h
    DynamicHashTable.h
    Bucket.h
    levenshtein.h
)

SET(xp-commons-test-srcs
    test/BucketTest.cpp
    test/HashStaticRecordTest.cpp
    test/DynamicHashTableTest.cpp)

ADD_EXECUTABLE(test/tester test/main.cpp ${xp-commons-test-srcs} ${xp-commons_library} )
TARGET_LINK_LIBRARIES(test/tester cppunit)


FOREACH(test ${xp-commons-test-srcs})
        GET_FILENAME_COMPONENT(TestName ${test} NAME_WE)
        ADD_TEST(${TestName} tester ${TestName})
ENDFOREACH(test)



# actual target:
ADD_LIBRARY(xp-commons SHARED ${xp-commons_library})
SET_TARGET_PROPERTIES(xp-commons PROPERTIES VERSION 0.0.0)

# add install target:
INSTALL(TARGETS xp-commons DESTINATION lib)

PROJECT(xp-commons)


