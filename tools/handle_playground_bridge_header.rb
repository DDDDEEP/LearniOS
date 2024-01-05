#!/usr/bin/ruby
# =======================================================
# == 根据是否启用 Playground，生成相应的 bridge-header 文件 ==
# =======================================================

require "fileutils"

# ================== 拷贝出用户自定义文件 ==================
project_dir = ENV["PROJECT_DIR"] || "#{__dir__}/.."
PLAYGROUND_HEADER_NAME = "Playground-Bridging-Header.h"
PLAYGROUND_HEADER_PATH = "#{project_dir}/LearniOSCore/Playground/#{PLAYGROUND_HEADER_NAME}"
PLAYGROUND_HEADER_DEFAULT_PATH = "#{PLAYGROUND_HEADER_PATH}.default"
USER_CONFIG_PATH = "#{project_dir}/Configuration/user.xcconfig"
USER_CONFIG_DEFAULT_PATH = "#{USER_CONFIG_PATH}.default"
if !File.exist?(PLAYGROUND_HEADER_PATH)
  FileUtils.cp(PLAYGROUND_HEADER_DEFAULT_PATH, PLAYGROUND_HEADER_PATH)
end
if !File.exist?(USER_CONFIG_PATH)
  FileUtils.cp(USER_CONFIG_DEFAULT_PATH, USER_CONFIG_PATH)
end

# ================== 开启 Playground 功能（已废弃） ==================
# IMPROT_LINE_CONTENT = "#import \"Playground-Bridging-Header.h\""
# COMMENT_IMPROT_LINE_CONTENT = "// #{IMPROT_LINE_CONTENT}"
# ENABLE_PLAYGROUND_CODE = ENV["ENABLE_PLAYGROUND_CODE"].to_i > 0

# BRIDGE_HEADER_PATH = "#{project_dir}/LearniOSInHouse/LearniOSInHouse-Bridging-Header.h"
# from_content = ENABLE_PLAYGROUND_CODE ? COMMENT_IMPROT_LINE_CONTENT : IMPROT_LINE_CONTENT
# to_content = ENABLE_PLAYGROUND_CODE ? IMPROT_LINE_CONTENT : COMMENT_IMPROT_LINE_CONTENT
# lines = File.readlines(BRIDGE_HEADER_PATH)
# lines.map! do |line|
#   line.gsub(/^#{Regexp.escape(from_content)}$/, to_content)
# end
# File.open(BRIDGE_HEADER_PATH, "w") do |file|
#   lines.each { |line| file.puts line }
# end
