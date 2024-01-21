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
    "USER_HEADER_SEARCH_PATHS" => '"${PODS_TARGET_SRCROOT}/**/**/*.{h,hpp}"',
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

  # ---------------- subspec ----------------
  s.subspec "Utils" do |ss|
    ss.source_files = "Utils/**/*.{h,m,mm,swift}"
    ss.public_header_files = "Utils/**/*.{h}"
  end

  s.subspec "Core" do |ss|
    ss.dependency "LearniOSCore/Utils"
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
