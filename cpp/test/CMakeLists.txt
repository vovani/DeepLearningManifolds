
add_executable(test ssht_reconstruction.cc)

target_link_libraries(test libssht.a fftw3 m)
