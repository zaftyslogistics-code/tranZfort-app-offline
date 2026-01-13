#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tranzfort_llm.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tranzfort_llm'
  s.version          = '0.0.1'
  s.summary          = 'On-device LLM inference using llama.cpp'
  s.description      = <<-DESC
Flutter plugin for on-device LLM inference using llama.cpp with Metal GPU acceleration on iOS.
                       DESC
  s.homepage         = 'https://github.com/zaftyslogistics-code/tranZfort-app-offline'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Zaftys Logistics' => 'zaftyslogistics@gmail.com' }
  s.source           = { :path => '.' }
  
  # Include Swift and Objective-C++ files
  s.source_files = 'Classes/**/*.{swift,h,m,mm}'
  
  # Vendored llama.cpp framework (will be built separately)
  s.vendored_frameworks = 'Frameworks/llama.xcframework'
  
  # Preserve directory structure for C++ headers
  s.preserve_paths = 'Classes/**/*.{h,mm}'
  
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Metal framework for GPU acceleration
  s.frameworks = 'Metal', 'MetalKit', 'MetalPerformanceShaders', 'Accelerate'

  # C++ configuration
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
    'CLANG_CXX_LIBRARY' => 'libc++',
    'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GGML_USE_METAL=1 GGML_METAL_NDEBUG=1',
    'OTHER_LDFLAGS' => '$(inherited) -framework Metal -framework MetalKit -framework Accelerate',
    'HEADER_SEARCH_PATHS' => '$(inherited) "${PODS_TARGET_SRCROOT}/Classes"'
  }
  
  s.swift_version = '5.0'
  s.libraries = 'c++'
  
  # Prepare command to build llama.cpp if needed
  s.prepare_command = <<-CMD
    echo "Preparing llama.cpp for iOS..."
    # Note: llama.cpp will be vendored or built via CMake
    # For now, we expect llama.cpp to be available in the vendor directory
  CMD
end
