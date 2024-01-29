#
# Be sure to run `pod lib lint LearniOSCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name = "LearniOSCore"
  s.version = "1.0.0"
  s.summary = "LearniOSCore"
  s.description = <<-DESC
LearniOS 的外部功能
DESC

  s.homepage = "https://github.com/DDDDEEP/LearniOS/"
  s.license = "MIT"
  s.author = { "DDDDEEP" => "517975369@qq.com" }
  s.source = { :git => "git@github.com:DDDDEEP/LearniOS.git", :tag => s.version.to_s }

  s.ios.deployment_target = "12.0"
  s.compiler_flags = "-Wall"
  s.pod_target_xcconfig = {
    "CLANG_CXX_LANGUAGE_STANDARD" => "gnu++17",
    "CLANG_CXX_LIBRARY" => "libc++",
  }
  s.xcconfig = {
#    "HEADER_SEARCH_PATHS" => '"${PODS_CONFIGURATION_BUILD_DIR}/${TARGET_NAME}/${PUBLIC_HEADERS_FOLDER_PATH}"',
#    "USER_HEADER_SEARCH_PATHS" => '"${PODS_CONFIGURATION_BUILD_DIR}/${TARGET_NAME}/${PUBLIC_HEADERS_FOLDER_PATH}"',
#    "USER_HEADER_SEARCH_PATHS" => '${SRCROOT}/../LearniOSCore/**/*.{h,hpp}',
#    "HEADER_SEARCH_PATHS" => '${SRCROOT}/../LearniOSCore/**/*.{h,hpp}',
#    "USER_HEADER_SEARCH_PATHS" => '${PODS_CONFIGURATION_BUILD_DIR}/LearniOSCore-BusinessUtils-Core-InHouse-Playground-Utils/LearniOSCore.framework/Headers',
#"HEADER_SEARCH_PATHS" => '"${PODS_TARGET_SRCROOT}/**/**/*.{h,hpp}"',
#"USER_HEADER_SEARCH_PATHS" => '"${PODS_TARGET_SRCROOT}/**/**/*.{h,hpp}"',
  }

  # ---------------- dependency ----------------
  s.dependency "KVOController", "~> 1.2.0"
  s.dependency "ReactiveCocoa"
  s.dependency "ReactiveObjC"
  s.dependency "Masonry"
  s.dependency "SnapKit"
  s.dependency "BlocksKit"
  s.dependency "Mantle"
  s.dependency "YYKit"
  s.dependency "fishhook"
  s.dependency "MGJRouter_Swift"
  s.dependency "OpenCombine"
  s.dependency "OpenCombineDispatch"
  s.dependency "CombineCocoa"

  # ---------------- subspec ----------------
  # 通用方法
  s.subspec "Utils" do |ss|
    ss.source_files = "Utils/**/*.{h,m,mm,swift}"
    ss.public_header_files = "Utils/**/*.{h}"
  end
  
  # 与工程逻辑相关的通用方法
  s.subspec "BusinessUtils" do |ss|
    ss.dependency "LearniOSCore/Utils"
    ss.source_files = "BusinessUtils/**/*.{h,m,mm,swift}"
    ss.public_header_files = "BusinessUtils/**/*.{h}"
  end

  s.subspec "Core" do |ss|
    ss.dependency "LearniOSCore/Utils"
    ss.dependency "LearniOSCore/BusinessUtils"
    ss.source_files = "Core/**/*.{h,m,mm,swift}"
    ss.public_header_files = "Core/**/*.{h}"
  end

  s.subspec "InHouse" do |ss|
    # ---------------- inhouse dependency ----------------
    ss.dependency "FLEX", "~> 4.4.1"
    ss.dependency "LookinServer"

    ss.dependency "LearniOSCore/Core"
    ss.source_files = "InHouse/**/*.{h,m,mm,swift}"
    ss.public_header_files = "InHouse/**/*.{h}"
  end
  
  s.subspec "Playground" do |ss|
    ss.source_files = "Playground/**/*.{h,m,mm,swift}"
    ss.public_header_files = "Playground/**/*.{h}"
  end
end
