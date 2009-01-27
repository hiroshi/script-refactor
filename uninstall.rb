# uninstall script/refactor
require "fileutils"
file_name = "script/refactor"
puts "          rm  #{file_name}"
FileUtils.rm File.dirname(__FILE__) + "/../../../#{file_name}"
