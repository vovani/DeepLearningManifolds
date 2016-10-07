
add_executable(ssht_test ssht/reconstruction.cc)
target_link_libraries(ssht_test ${GTEST_BOTH_LIBRARIES} ${Boost_LIBRARIES} ${SSHT_LINK_LIBRARIES} m)

add_custom_target(run_tests
                  COMMAND ./ssht_test
                  DEPENDS ssht_test
                  )
