set(TEST_SRSC ssht_reconstruction.c)

add_executable(test ${TEST_SRSC})
add_executable(test2 ssht_reconstruction.cc)

target_link_libraries(test libssht.a fftw3 m)
target_link_libraries(test2 libssht.a fftw3 m)
