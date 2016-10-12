cmake_minimum_required(VERSION 2.8)
project(DLM)

set(CMAKE_C_COMPILER "gcc")

set(CMAKE_CXX_COMPILER "g++")
set(CMAKE_CXX_FLAGS ${CMAKE_CXX_DEFAULT_FLAGS} " -std=c++14 -Wall -Weffc++")
set(CMAKE_CXX_FLAGS_RELEASE " -O3 -funroll-loops -flto -march=native -mtune=native")

if("${CMAKE_BUILD_TYPE}" STREQUAL "")
    message("Setting CMAKE_BUILD_TYPE to RELEASE")
    set(CMAKE_BUILD_TYPE "RELEASE")
endif()

add_definitions(-DLOCAL_RESOURCE_DIR=\"${CMAKE_SOURCE_DIR}/resources\")
include_directories(src) 

find_package(GTest REQUIRED)
find_package(Boost REQUIRED
             COMPONENTS filesystem)

include (ExternalProject)

ExternalProject_Add(ssht
                    GIT_REPOSITORY https://github.com/vovani/ssht.git 
                    GIT_TAG public
                    CONFIGURE_COMMAND ""
                    BUILD_COMMAND make
                    BUILD_IN_SOURCE 1
                    INSTALL_COMMAND ""
                    UPDATE_DISCONNECTED 1
)

ExternalProject_Get_Property(ssht source_dir)
set(SSHT_SOURCE_DIR ${source_dir})
set(SSHT_INCLUDE_DIR ${SSHT_SOURCE_DIR}/include/c)
set(SSHT_LIBRARY_DIR ${SSHT_SOURCE_DIR}/lib/c)
set(SSHT_LINK_LIBRARIES fftw3 libssht.a)


link_directories(${SSHT_LIBRARY_DIR})
include_directories(src ${SSHT_INCLUDE_DIR})

add_subdirectory(test)
add_subdirectory(python)
