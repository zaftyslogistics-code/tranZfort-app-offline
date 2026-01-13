#!/bin/bash
# Build script for llama.cpp iOS framework
# This script builds llama.cpp as an XCFramework for iOS devices and simulator

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LLAMA_SRC="${SCRIPT_DIR}/../android/src/main/cpp/vendor/llama.cpp"
BUILD_DIR="${SCRIPT_DIR}/build"
FRAMEWORKS_DIR="${SCRIPT_DIR}/Frameworks"

echo "Building llama.cpp for iOS..."

# Clean previous builds
rm -rf "${BUILD_DIR}"
rm -rf "${FRAMEWORKS_DIR}"
mkdir -p "${BUILD_DIR}"
mkdir -p "${FRAMEWORKS_DIR}"

# Build for iOS device (arm64)
echo "Building for iOS device (arm64)..."
cmake -S "${LLAMA_SRC}" -B "${BUILD_DIR}/ios-arm64" \
  -DCMAKE_SYSTEM_NAME=iOS \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=13.0 \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=OFF \
  -DLLAMA_BUILD_TESTS=OFF \
  -DLLAMA_BUILD_EXAMPLES=OFF \
  -DLLAMA_BUILD_SERVER=OFF \
  -DLLAMA_METAL=ON \
  -DGGML_METAL=ON \
  -DGGML_METAL_EMBED_LIBRARY=ON

cmake --build "${BUILD_DIR}/ios-arm64" --config Release

# Build for iOS simulator (arm64 + x86_64)
echo "Building for iOS simulator..."
cmake -S "${LLAMA_SRC}" -B "${BUILD_DIR}/ios-simulator" \
  -DCMAKE_SYSTEM_NAME=iOS \
  -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=13.0 \
  -DCMAKE_OSX_SYSROOT=iphonesimulator \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=OFF \
  -DLLAMA_BUILD_TESTS=OFF \
  -DLLAMA_BUILD_EXAMPLES=OFF \
  -DLLAMA_BUILD_SERVER=OFF \
  -DLLAMA_METAL=OFF \
  -DGGML_METAL=OFF

cmake --build "${BUILD_DIR}/ios-simulator" --config Release

# Create XCFramework
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -library "${BUILD_DIR}/ios-arm64/src/libllama.a" \
  -headers "${LLAMA_SRC}/include" \
  -library "${BUILD_DIR}/ios-simulator/src/libllama.a" \
  -headers "${LLAMA_SRC}/include" \
  -output "${FRAMEWORKS_DIR}/llama.xcframework"

echo "Build complete! XCFramework created at: ${FRAMEWORKS_DIR}/llama.xcframework"
