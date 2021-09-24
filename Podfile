source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

project "LearniOS", "LearniOSDebug" => :debug, "LearniOSInHouseDebug" => :debug, "LearniOSInHouseTest" => :debug

#######################################
#               Pods                  #
#######################################

def app
  pod 'KVOController', '~> 1.2.0'
end

def debug_pods
  pod 'FLEX', '~> 4.4.1'
  pod 'LookinServer', '~> 1.0.3'
end


#######################################
#               Targets               #
#######################################

target "LearniOS" do
  app
end

target "LearniOSInHouse" do
  app
  debug_pods
end

target 'LearniOSTests' do
  app
end
