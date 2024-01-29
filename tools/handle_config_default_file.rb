#!/usr/bin/ruby
# =======================================================
# ==           拷贝所有的 xxx.default 文件               ==
# =======================================================

require "fileutils"
require "find"

def copy_default_file_if_not_exists(default_path)
  path = default_path.gsub('.default', '')
  if !File.exist?(path)
    FileUtils.cp(default_path, path)
  end
end

def find_default_files(directory)
  default_files = []
  Find.find(directory) do |path|
    default_files << path if path =~ /.*\.default$/
  end
  default_files
end

# ================== 拷贝出用户自定义文件 ==================
project_dir = ENV["PROJECT_DIR"] || "#{__dir__}/.."
PLAYGROUND_HEADER_DEFAULT_PATH = "#{project_dir}/LearniOSCore/Playground/Playground-Bridging-Header.h.default"
USER_CONFIG_DEFAULT_PATH = "#{project_dir}/Configuration/user.xcconfig.default"
CONFIG_DEFAULT_PATH = "#{project_dir}/config.rb.default"

copy_default_file_if_not_exists(PLAYGROUND_HEADER_DEFAULT_PATH)
copy_default_file_if_not_exists(USER_CONFIG_DEFAULT_PATH)
copy_default_file_if_not_exists(CONFIG_DEFAULT_PATH)

playground_task_default_files = find_default_files("#{project_dir}/LearniOSCore/Playground/Task")
playground_task_default_files.each do |default_path|
    copy_default_file_if_not_exists(default_path)
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
