# place script/refactor
open(File.dirname(__FILE__) + "../../script/refactor") do |file|
  file.print <<-FILE
#!/usr/bin/env ruby                                                                                                                     
require File.dirname(__FILE__) + '/../vendor/plugins/script_refactor/lib/script_refactor'
  FILE
end

