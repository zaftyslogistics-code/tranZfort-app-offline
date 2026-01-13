cmake_minimum_required(VERSION 3.18.1)

project(tranzfort_llm)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Android NDK + CMake thread detection workaround.
# CMake's FindThreads probes for pthread_cancel(), which is not available on Android (bionic),
# but pthreads are supported. Force Threads to be considered available.
if (ANDROID)
  set(THREADS_PREFER_PTHREAD_FLAG ON CACHE BOOL "" FORCE)
  set(CMAKE_THREAD_LIBS_INIT "-pthread" CACHE STRING "" FORCE)
  set(CMAKE_HAVE_LIBC_PTHREAD 1 CACHE BOOL "" FORCE)
  set(CMAKE_USE_PTHREADS_INIT 1 CACHE BOOL "" FORCE)
  set(Threads_FOUND TRUE CACHE BOOL "" FORCE)
endif()

set(LLAMA_CPP_DIR "${CMAKE_CURRENT_SOURCE_DIR}/vendor/llama.cpp")
if (EXISTS "${LLAMA_CPP_DIR}/CMakeLists.txt")
  message(STATUS "tranzfort_llm: llama.cpp sources detected at ${LLAMA_CPP_DIR}")

  # Build llama.cpp as static libs and avoid extra artifacts.
  set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
  set(LLAMA_BUILD_TESTS OFF CACHE BOOL "" FORCE)
  set(LLAMA_BUILD_TOOLS OFF CACHE BOOL "" FORCE)
  set(LLAMA_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
  set(LLAMA_BUILD_SERVER OFF CACHE BOOL "" FORCE)
  set(LLAMA_BUILD_COMMON OFF CACHE BOOL "" FORCE)
  
  # Disable native CPU optimization detection for Android cross-compilation.
  # Android API 24 arm64-v8a baseline doesn't support advanced ARM features like DOTPROD, SVE, etc.
  set(GGML_NATIVE OFF CACHE BOOL "" FORCE)

  add_subdirectory("${LLAMA_CPP_DIR}" "${CMAKE_BINARY_DIR}/llama.cpp")
else()
  message(STATUS "tranzfort_llm: llama.cpp sources not found (using stub backend)")
endif()

add_library(
  tranzfort_llm_native
  SHARED
  tranzfort_llm_jni.cpp
  tranzfort_llm_backend.cpp
)

find_library(
  log-lib
  log
)

target_compile_features(tranzfort_llm_native PRIVATE cxx_std_17)

target_link_libraries(
  tranzfort_llm_native
  PRIVATE ${log-lib}
)

if (TARGET llama)
  target_link_libraries(tranzfort_llm_native PRIVATE llama)
endif()
