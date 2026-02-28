cmake_minimum_required (VERSION 3.4.1)

project (hmc_test CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(TEST_TARGET_PROJECT_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/..)
set(TEST_TARGET_SOURCE_DIR ${TEST_TARGET_PROJECT_ROOT_DIR}/sdk/src)
set(LIBS_DIR    ${TEST_TARGET_PROJECT_ROOT_DIR}/sdk/libs)

include(${CMAKE_CURRENT_SOURCE_DIR}/third_party/cmake/Fetchgtest.cmake)

include_directories("${CMAKE_CURRENT_SOURCE_DIR}/third_party/googletest/googletest/include")

link_directories(${LIBS_DIR}/turbojpeg/ohos/${OHOS_ARCH})
link_directories(${LIBS_DIR}/SecureC/ohos/${OHOS_ARCH})
link_directories(${LIBS_DIR}/JsonCpp/ohos/${OHOS_ARCH})
link_directories(${LIBS_DIR}/ffrt/ohos/${OHOS_ARCH})
link_directories(${LIBS_DIR}/AiModelRef/ohos/${OHOS_ARCH})
link_directories(${CMAKE_CURRENT_SOURCE_DIR}/out/unittest/common)

file(GLOB_RECURSE TESTCASE_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/stub/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/unitest/*.cpp
   ${CMAKE_CURRENT_SOURCE_DIR}/moduletest/*.cpp
)

add_executable(${PROJECT_NAME}
    ${TESTCASE_FILES}
)

target_include_directories(${PROJECT_NAME} PUBLIC
    ${TEST_TARGET_PROJECT_ROOT_DIR}/sdk/include
    ${TEST_TARGET_PROJECT_ROOT_DIR}/sdk/interface
    ${TEST_TARGET_SOURCE_DIR}/Base
    ${TEST_TARGET_SOURCE_DIR}/Engine
    ${TEST_TARGET_SOURCE_DIR}/Service
    ${TEST_TARGET_SOURCE_DIR}/Bridge
    ${LIBS_DIR}/FFmpeg/ohos/include
    ${LIBS_DIR}/JsonCpp/include
    ${LIBS_DIR}/GLM
    ${LIBS_DIR}/turbojpeg/include
    ${LIBS_DIR}/ffrt/include
    ${LIBS_DIR}/AiModelRef/include)

target_link_libraries(${PROJECT_NAME} gtest_main MediaCreativity
    native_window native_image GLESv3
)
