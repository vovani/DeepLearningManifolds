
add_executable(ssht_test ssht_reconstruction.cc)
target_link_libraries(ssht_test ${GTEST_BOTH_LIBRARIES} libssht.a fftw3 m)

add_custom_target(run_tests
                  COMMAND ./ssht_test
                  DEPENDS ssht_test
                  )