#!/usr/bin/ruby
# =====================================================================
# == 根据工程目录解析 Group & FileRef, Complie Source, Bundle Resources ==
# =====================================================================

require "xcodeproj"

# ================== 定义常量 ==================
PROJECT_NAME = "LearniOS"
PROJECT_FILE_NAME = "#{PROJECT_NAME}.xcodeproj"
# 不希望编译的 Group
IGNORE_GROUP_REGEX = ENV["ENABLE_PLAYGROUND_CODE"].to_i > 0 ? /\.xcassets$/ : /(\.xcassets|Playground)$/
# 只加入到 Group 的文件
FILE_REF_PATTERN = "*.{h,plist,entitlements}"
# 加入到 Group，且作为 Complie Source 的文件
COMPILE_SOURCE_PATTERN = "*.{m,mm,c,cpp,swift}"
# 加入到 Group，且作为 Bundle Resources 的文件
RESOURCES_BUILD_PATTERN = "*.{xcassets,storyboard}"

# ===============================================
# ================== 定义辅助函数 ==================
# ===============================================

# 递归地获取根路径下，所有子目录的相对路径
#
# @param root_path [String] 根路径
# @param path [String] 指向文件夹的相对路径
# @param include_root [Boolean] 返回值是否包含根目录在内，默认为 true
# @return [Array] 包含所有子目录路径的数组（注：返回值不含根路径信息）
def GetFolderListForPath(root_path, path = "", include_root = true)
  directories = []
  # 在第一次方法调用时将根目录添加到返回值
  directories << File.basename(root_path) if include_root
  entries = Dir.entries(File.join(root_path, path)) - [".", ".."]
  entries.each do |entry|
    relative_path = File.join(path, entry)
    full_path = File.join(root_path, relative_path)
    if File.directory?(full_path) && relative_path !~ IGNORE_GROUP_REGEX
      # 移除路径开头的"/"
      relative_path = relative_path[0] == "/" ? relative_path[1..-1] : relative_path
      directories << File.join(File.basename(root_path), relative_path)
      directories.concat(GetFolderListForPath(root_path, relative_path, false)) unless full_path =~ IGNORE_GROUP_REGEX
    end
  end
  directories
end

# 解析指定根目录的 Group & FileRef，并返回其中的 Complie Source, Bundle Resources
#
# @param root_path [String] 根路径
# @param main_group [PBXGroup] 工程的主目录
# @return [Array] 返回元组 [complie_source, bundle_resources]
def ParseGroupRefForFolder(root_path, main_group)
  header_file_refs = []
  file_refs = []
  resource_refs = []
  group_subpath_list = GetFolderListForPath(root_path)
  group_subpath_list.each do |group_subpath|
    new_group = main_group.find_subpath(group_subpath, true)
    new_group.clear
    project_dir = main_group.real_path
    header_fullpath_list = Dir.glob("#{project_dir}/#{group_subpath}/#{FILE_REF_PATTERN}")
    file_fullpath_list = Dir.glob("#{project_dir}/#{group_subpath}/#{COMPILE_SOURCE_PATTERN}")
    resouce_fullpath_list = Dir.glob("#{project_dir}/#{group_subpath}/#{RESOURCES_BUILD_PATTERN}")

    header_file_refs.concat(header_fullpath_list.map { |file_fullpath| new_group.new_reference(file_fullpath) })
    file_refs.concat(file_fullpath_list.map { |file_fullpath| new_group.new_reference(file_fullpath) })
    resource_refs.concat(resouce_fullpath_list.map { |file_fullpath| new_group.new_reference(file_fullpath) })

    new_group.sort
  end
  [file_refs, resource_refs]
end

# ================== 业务逻辑 ==================
project_dir = ENV["PROJECT_DIR"] || "#{__dir__}/.."
project_file_path = ENV["PROJECT_FILE_PATH"] || "#{project_dir}/#{PROJECT_FILE_NAME}"
project = Xcodeproj::Project.open(project_file_path)

ProjectTarget = Struct.new(:target, :complie_source, :bundle_resources)
normal_target = nil
inhouse_target = nil
test_target = nil
project_targets = []

project.targets.each do |target|
  target.source_build_phase.clear
  target.resources_build_phase.clear

  target_ref = ProjectTarget.new(target, [], [])
  if target.name == "#{PROJECT_NAME}"
    normal_target = target_ref
  elsif target.name == "#{PROJECT_NAME}InHouse"
    inhouse_target = target_ref
  elsif target.name.end_with?("Tests")
    test_target = target_ref
  end
  target_group_path = "#{project_dir}/#{target.name}"
  target_ref.complie_source, target_ref.bundle_resources = ParseGroupRefForFolder(target_group_path, project.main_group)

  project_targets << target_ref
end
inhouse_target.complie_source.concat(normal_target.complie_source)
inhouse_target.bundle_resources.concat(normal_target.bundle_resources)

project_targets.each do |p_target|
  p_target.target.add_file_references(p_target.complie_source)
  p_target.target.add_resources(p_target.bundle_resources)
end

project.main_group.sort_by_type
project.save
