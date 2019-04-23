################################################################################
## Data analysis project based on J-PET Framework
## Created by J-PET Framework developers 2016-2018
##
## Description:
##   Builds project for analysis of Monte Carlo generated data
################################################################################

cmake_minimum_required(VERSION 2.6)

################################################################################
## Project name
set(projectName run4)

## Auxiliary files
set(AUXILLIARY_FILES
  userParams.json
  runMC.sh
  runData.sh
)

set(ROOT_SCRIPTS
  rootlogon.C
  rootalias.C
)

################################################################################
## Binary, header and source files definitions
set(projectBinaryData data_${projectName}.x)
set(projectBinaryMC mc_${projectName}.x)
project(${projectName} CXX)
file(GLOB HEADERS *.h)
file(GLOB SOURCES *.cpp)
list(REMOVE_ITEM SOURCES "${CMAKE_SOURCE_DIR}/MCDataComparison_run4/mainData.cpp" "${CMAKE_SOURCE_DIR}/MCDataComparison_run4/mainMC.cpp")

######################################################################
## Use source files of modules from LargeBarrelAnalysis
set(use_modules_from ../LargeBarrelAnalysis)
list(APPEND HEADERS ${use_modules_from}/TimeWindowCreator.h)
list(APPEND SOURCES ${use_modules_from}/TimeWindowCreator.cpp)
list(APPEND HEADERS ${use_modules_from}/TimeWindowCreatorTools.h)
list(APPEND SOURCES ${use_modules_from}/TimeWindowCreatorTools.cpp)
list(APPEND HEADERS ${use_modules_from}/UniversalFileLoader.h)
list(APPEND SOURCES ${use_modules_from}/UniversalFileLoader.cpp)
list(APPEND HEADERS ${use_modules_from}/SignalFinder.h)
list(APPEND SOURCES ${use_modules_from}/SignalFinder.cpp)
list(APPEND HEADERS ${use_modules_from}/SignalFinderTools.h)
list(APPEND SOURCES ${use_modules_from}/SignalFinderTools.cpp)
list(APPEND HEADERS ${use_modules_from}/SignalTransformer.h)
list(APPEND SOURCES ${use_modules_from}/SignalTransformer.cpp)
list(APPEND HEADERS ${use_modules_from}/HitFinder.h)
list(APPEND SOURCES ${use_modules_from}/HitFinder.cpp)
list(APPEND HEADERS ${use_modules_from}/HitFinderTools.h)
list(APPEND SOURCES ${use_modules_from}/HitFinderTools.cpp)
list(APPEND HEADERS ${use_modules_from}/EventFinder.h)
list(APPEND SOURCES ${use_modules_from}/EventFinder.cpp)
list(APPEND HEADERS ${use_modules_from}/EventCategorizer.h)
list(APPEND SOURCES ${use_modules_from}/EventCategorizer.cpp)
list(APPEND HEADERS ${use_modules_from}/EventCategorizerTools.h)
list(APPEND SOURCES ${use_modules_from}/EventCategorizerTools.cpp)


include_directories(${Framework_INCLUDE_DIRS})
add_definitions(${Framework_DEFINITIONS})

add_executable(${projectBinaryData} mainData.cpp ${SOURCES} ${HEADERS})
target_link_libraries(${projectBinaryData} JPetFramework)

add_executable(${projectBinaryMC} mainMC.cpp ${SOURCES} ${HEADERS})
target_link_libraries(${projectBinaryMC} JPetFramework)


add_custom_target(clean_data_${projectName}
  COMMAND rm -f *.tslot.*.root *.phys.*.root *.sig.root
)

add_custom_target(clean_log
  COMMAND rm -f *.log
)

## Create variable for list with depends files path
set(copy_depends)

################################################################################
## Copy the example auxiliary files
foreach(file_i ${AUXILLIARY_FILES})
  list(APPEND copy_depends ${CMAKE_CURRENT_BINARY_DIR}/${file_i})
  if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${file_i})
    set(CP_CMD copy_directory)
  else()
    set(CP_CMD copy)
  endif()
  add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${file_i}
    POST_BUILD COMMAND ${CMAKE_COMMAND}
    ARGS -E ${CP_CMD} ${CMAKE_CURRENT_SOURCE_DIR}/${file_i} ${CMAKE_CURRENT_BINARY_DIR}/${file_i}
  )
endforeach(file_i)

## Copy the ROOT scripts
foreach(file_i ${ROOT_SCRIPTS})
  list(APPEND copy_depends ${CMAKE_CURRENT_BINARY_DIR}/${file_i})
  add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${file_i}
    POST_BUILD COMMAND ${CMAKE_COMMAND}
    ARGS -E ${CP_CMD} ${CMAKE_CURRENT_SOURCE_DIR}/../scripts/${file_i} ${CMAKE_CURRENT_BINARY_DIR}/${file_i}
  )
endforeach(file_i)

################################################################################
## Add new target that depends on copied files
add_custom_target(copy_files_${projectName} DEPENDS ${copy_depends})
## Add dependencies between building project and copy files
add_dependencies(${projectBinaryData} copy_files_${projectName})

set(target ${CMAKE_CURRENT_SOURCE_DIR}/../CalibrationFiles/4_RUN)
set(link ${CMAKE_CURRENT_BINARY_DIR}/4_RUN)
ADD_CUSTOM_TARGET(link_target ALL
                    COMMAND ${CMAKE_COMMAND} -E create_symlink ${target} ${link})


ADD_CUSTOM_TARGET(link_targetDATA ALL  COMMAND ${CMAKE_COMMAND} -E create_symlink /home/daria/massive/jpet_data/run4/2017.09.06_0001 data)
ADD_CUSTOM_TARGET(link_targetMC ALL  COMMAND ${CMAKE_COMMAND} -E create_symlink /home/daria/massive/jpet_data/run4/mc mc)
