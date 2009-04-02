require File.dirname(__FILE__) + '/rename_refactoring'

module Refactor
  VERSION = "0.2"
end
# usage
if ARGV.size != 3
  puts <<-USAGE
script-refactor #{Refactor::VERSION}

Help refactoring application:
* Renaming files with scm aware manner
* Replacing class names, variable names as possible
* Generate renaming migration file

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

# arguments
type, from, to = ARGV
rename = RenameRefactoring.new(File.expand_path('.'), from, to)
rename.apply
