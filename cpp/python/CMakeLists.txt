find_package(SWIG REQUIRED)
include(${SWIG_USE_FILE})

find_package(PythonLibs 2.7 REQUIRED)
include_directories(${PYTHON_INCLUDE_DIRS})

set_source_files_properties(dlm.i PROPERTIES CPLUSPLUS ON)

swig_add_module(dlm python dlm.i)
swig_link_libraries(dlm ${PYTHON_LIBRARIES} ${SSHT_LINK_LIBRARIES})
