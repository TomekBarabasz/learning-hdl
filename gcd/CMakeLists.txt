cmake_minimum_required(VERSION 3.16)
project(VGCD)
find_package(PkgConfig REQUIRED)
find_package(verilator HINTS $ENV{VERILATOR_ROOT} ${VERILATOR_ROOT})
if (NOT verilator_FOUND)
  message(FATAL_ERROR "Verilator was not found. Either install it, or set the VERILATOR_ROOT environment variable")
endif()
pkg_check_modules(GTEST REQUIRED gtest>=1.8.1)

include_directories(${GTEST_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR} )
link_directories( ${GTEST_LIBRARY_DIRS} )
add_definitions(${GTEST_CFLAGS_OTHER})

message( "GTEST_LIBRARY_DIRS " "${GTEST_LIBRARY_DIRS}")
add_library(VGCD_lib SHARED py_wrapper.cpp)
add_executable(VGCD gcd_main.cpp gcd_test_01.cpp)
target_link_libraries(VGCD PUBLIC VGCD_lib gtest gtest_main pthread)

verilate(VGCD_lib 
	INCLUDE_DIRS "."
	SOURCES GCD.v)
