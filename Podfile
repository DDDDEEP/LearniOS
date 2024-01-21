#source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

#######################################
#               Custom                #
#######################################
# 创建用户文件
puts "================== Handle Config Default File BEGIN =================="
system("bundle exec ruby ./tools/handle_config_default_file.rb")
puts "================== Handle Config Default File END =================="
puts ""

puts "================== User Config BEGIN =================="
require "./config.rb"
puts "ENABLE_PLAYGROUND_CODE=#{ENABLE_PLAYGROUND_CODE}"
puts "================== User Config END =================="
puts ""

#######################################
#               Pods                  #
#######################################

# Uncomment the next line to define a global platform for your project
MIN_IOS_VERSION = 12.0
platform :ios, "#{MIN_IOS_VERSION}"

# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

project "LearniOS", "LearniOSDebug" => :debug, "LearniOSRelease" => :release, "LearniOSInHouseDebug" => :debug, "LearniOSInHouseRelease" => :release, "LearniOSInHouseTest" => :debug

def common_pods
  pod 'YYKit', git: 'https://github.com/xiaoerlong/YYKit.git'
  pod "LearniOSCore", :modular_headers => true, :inhibit_warnings => false, :subspecs => ["Core"], :path => "./LearniOSCore/"
end

def inhouse_pods
  subspecs = ["InHouse"]
  if ENABLE_PLAYGROUND_CODE > 0
    subspecs << "Playground"
  end
  pod "LearniOSCore", :modular_headers => true, :inhibit_warnings => false, :subspecs => subspecs, :path => "./LearniOSCore/"
end

#######################################
#               Targets               #
#######################################

target "LearniOSInHouse" do
  common_pods
  inhouse_pods
end

target "LearniOS" do
  common_pods
end

target "LearniOSTests" do
  common_pods
end

#def append_header_search_path(target, path)
#  target.build_configurations.each do |config|
#    # Note that there's a space character after `$(inherited)`.
#    config.build_settings["HEADER_SEARCH_PATHS"] ||= "$(inherited) "
#    config.build_settings["HEADER_SEARCH_PATHS"] << path
#  end
#end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"].to_f < MIN_IOS_VERSION
        config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "#{MIN_IOS_VERSION}"
      end
      #      config.build_settings["USER_HEADER_SEARCH_PATHS"] ||= "${PROJECT_DIR}/LearniOSCore/**/* "
      #      config.build_settings["USER_HEADER_SEARCH_PATHS"] << ""
    end
  end

  # system("bundle exec ruby ./tools/merge_complie_sources.rb")
end
