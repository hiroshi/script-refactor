# install script/refactor
open(File.dirname(__FILE__) + "/../../../script/refactor", "w") do |file|
  file.print <<-SCRIPT
#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../vendor/plugins/script_refactor/lib/script_refactor'
  SCRIPT
  file.chmod(0755) # make executable
end
