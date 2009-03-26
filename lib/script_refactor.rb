=begin
TODO:
* Please refactor me
* Ignore db directory and create migration?
=end
module Refactor
  VERSION = "0.1"
end
# usage
if ARGV.size != 3
  puts <<-USAGE
script-refactor #{Refactor::VERSION}

Help refactoring application:
* Renaming files with git, svn aware manner
* Replacing class names, variable names as possible

THIS SCRIPT MAY DESTRUCT FILES AND/OR DIRECTORIES OF YOUR RAILS APPLICATION.
BE SURE YOUR CHANGES ARE COMMITED OR BACKED UP!

Usage: 
  #{$0} type from to

Possible types:

  resource: Replace resource name.

Supported SCM: git, svn

Examples:
  #{$0} resource user person

  USAGE
  exit 1
end

require File.dirname(__FILE__) + '/util'

# arguments
type, from, to = ARGV
Util.apply_rename_refactoring(type, from, to)
