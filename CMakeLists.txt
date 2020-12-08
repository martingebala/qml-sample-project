cmake_minimum_required(VERSION 3.15)
project(qml-assignment CXX)
set(CMAKE_CXX_STANDARD 17)

find_package(Qt5 COMPONENTS Widgets Quick REQUIRED)

add_executable(linear_stage WIN32
    imports/qml.qrc
    include/linear_stage/linear_stage.hpp
    src/main.cpp
    src/linear_stage.cpp
)

set_target_properties(linear_stage PROPERTIES
    AUTOMOC ON
    AUTOUIC ON
    AUTORCC ON
)

target_include_directories(linear_stage PUBLIC include)

target_link_libraries(linear_stage PRIVATE
    Qt5::Widgets
    Qt5::Quick
)

# We enable debug by default since it's a test application
target_compile_definitions(linear_stage PRIVATE QT_QML_DEBUG)
