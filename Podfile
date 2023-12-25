#source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

#######################################
#               Envs                  #
#######################################
ENABLE_PLAYGROUND_CODE = 0

#######################################
#               Pods                  #
#######################################

ENV["ENABLE_PLAYGROUND_CODE"] = ENABLE_PLAYGROUND_CODE.to_s
system("bundle exec ruby ./tools/handle_playground_bridge_header.rb")

# Uncomment the next line to define a global platform for your project
MIN_IOS_VERSION = 12.0
platform :ios, "#{MIN_IOS_VERSION}"

# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

project "LearniOS", "LearniOSDebug" => :debug, "LearniOSInHouseDebug" => :debug, "LearniOSInHouseTest" => :debug

def app
  pod "KVOController", "~> 1.2.0"
  #  pod 'BaiduMapKit', '~> 6.4.0'
  pod "ReactiveCocoa"
  pod "ReactiveObjC"
  pod "Masonry"
  pod "SnapKit"
  pod "BlocksKit"
  pod "Mantle"
  #  pod 'Yoga'
  #  pod 'YogaKit'
end

def debug_pods
  pod "FLEX", "~> 4.4.1"
  pod "LookinServer"
end

#######################################
#               Targets               #
#######################################

target "LearniOSInHouse" do
  app
  debug_pods
end

target "LearniOS" do
  app
end

target "LearniOSTests" do
  app
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"].to_f < MIN_IOS_VERSION
        config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "#{MIN_IOS_VERSION}"
      end
    end
  end

  system("bundle exec ruby ./tools/merge_complie_sources.rb")
end
