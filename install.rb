# install script/refactor
require "fileutils"
file_name = "script/refactor"
puts "      create  #{file_name}"
dst = File.dirname(__FILE__) + "/../../../#{file_name}"
src = File.dirname(__FILE__) + "/#{file_name}"
# open(path, "w") do |file|
#   file.print <<-SCRIPT
# #!/usr/bin/env ruby
# require File.dirname(__FILE__) + '/../vendor/plugins/script_refactor/lib/script_refactor'
#   SCRIPT
#   file.chmod(0755) # make it executable
# end
FileUtils.copy(src, dst)
