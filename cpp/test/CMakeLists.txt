set(TEST_SRSC ssht_reconstruction.c)

add_executable(test ${TEST_SRSC})
target_link_libraries(test libssht.a fftw3 m)
