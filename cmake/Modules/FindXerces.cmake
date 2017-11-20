# - Try to find Xerces-C
# Once done this will define
#
#  XERCESC_FOUND - system has Xerces-C
#  XERCESC_INCLUDE - the Xerces-C include directory
#  XERCESC_LIBRARY - Link these to use Xerces-C
#  XERCESC_VERSION - Xerces-C found version

if (XERCESC_INCLUDE AND XERCESC_LIBRARY)
# in cache already
set(XERCESC_FIND_QUIETLY TRUE)
endif ()

option(XERCESC_STATIC "Set to ON to link your project with static library (instead of DLL)." ON)

if (NOT  ${XERCESC_WAS_STATIC} STREQUAL ${XERCESC_STATIC})
unset(XERCESC_LIBRARY CACHE)
unset(XERCESC_LIBRARY_DEBUG CACHE)
endif ()

set(XERCESC_WAS_STATIC ${XERCESC_STATIC} CACHE INTERNAL "" )

find_path(XERCESC_INCLUDE NAMES xercesc/util/XercesVersion.hpp
PATHS
$ENV{XERCESC_INCLUDE_DIR}
${XERCESC_INCLUDE_DIR}
 /usr/local/include
 /usr/include
)

if (XERCESC_STATIC)
find_library(XERCESC_LIBRARY NAMES xerces-c_static_3 xerces-c-3.1 xerces-c
 PATHS
 $ENV{XERCESC_LIBRARY_DIR}
 ${XERCESC_LIBRARY_DIR}
 /usr/lib
 /usr/lib/x86_64-linux-gnu/
 /usr/local/lib

)
find_library(XERCESC_LIBRARY_DEBUG NAMES xerces-c_static_3D xerces-c-3.1D
 PATHS
 $ENV{XERCESC_LIBRARY_DIR}
 ${XERCESC_LIBRARY_DIR}
 /usr/lib
 /usr/lib/x86_64-linux-gnu/
 /usr/local/lib

)
add_definitions( -DXERCES_STATIC_LIBRARY )
else ()
find_library(XERCESC_LIBRARY NAMES xerces-c_3
 PATHS
 $ENV{XERCESC_LIBRARY_DIR}
 ${XERCESC_LIBRARY_DIR}
 /usr/lib

)
find_library(XERCESC_LIBRARY_DEBUG NAMES xerces-c_3D
 PATHS
 $ENV{XERCESC_LIBRARY_DIR}
 ${XERCESC_LIBRARY_DIR}
 /usr/lib

)
endif ()

if (XERCESC_INCLUDE AND XERCESC_LIBRARY)
set(XERCESC_FOUND TRUE)
else ()
set(XERCESC_FOUND FALSE)
endif ()

if(XERCESC_FOUND)

find_path(XERCESC_XVERHPPPATH NAMES XercesVersion.hpp PATHS
 ${XERCESC_INCLUDE}
 PATH_SUFFIXES xercesc/util)

if ( ${XERCESC_XVERHPPPATH} STREQUAL XERCESC_XVERHPPPATH-NOTFOUND )
 set(XERCES_VERSION "0")
else()
 file(READ ${XERCESC_XVERHPPPATH}/XercesVersion.hpp XVERHPP)

 string(REGEX MATCHALL "\n *#define XERCES_VERSION_MAJOR +[0-9]+" XVERMAJ
   ${XVERHPP})
 string(REGEX MATCH "\n *#define XERCES_VERSION_MINOR +[0-9]+" XVERMIN
   ${XVERHPP})
 string(REGEX MATCH "\n *#define XERCES_VERSION_REVISION +[0-9]+" XVERREV
   ${XVERHPP})

 string(REGEX REPLACE "\n *#define XERCES_VERSION_MAJOR +" ""
   XVERMAJ ${XVERMAJ})
 string(REGEX REPLACE "\n *#define XERCES_VERSION_MINOR +" ""
   XVERMIN ${XVERMIN})
 string(REGEX REPLACE "\n *#define XERCES_VERSION_REVISION +" ""
   XVERREV ${XVERREV})

 set(XERCESC_VERSION ${XVERMAJ}.${XVERMIN}.${XVERREV})

endif ()

if(NOT XERCESC_FIND_QUIETLY)
 message(STATUS "Found Xerces-C: ${XERCESC_LIBRARY}")
 message(STATUS "              : ${XERCESC_INCLUDE}")
 message(STATUS "       Version: ${XERCESC_VERSION}")
endif()
else()
message(FATAL_ERROR "Could not find Xerces-C !")
endif()

mark_as_advanced(XERCESC_INCLUDE XERCESC_LIBRARY)
