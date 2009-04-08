require 'optparse'
require File.dirname(__FILE__) + '/rename_refactoring'

# == parse command line arguments
options = {}
opts = OptionParser.new do |opts|
  opts.set_summary_indent('  ')
  opts.program_name = "script/refactor"
  opts.version = "0.3"
  opts.banner = "Usage: #{opts.program_name} [OPTIONS] type from to"
  opts.on_head <<-HEAD

Help rails application refactoring:
* Renaming files with scm aware manner
* Replacing class names, variable names as possible
* Generate renaming migration file

THIS SCRIPT MAY DESTRUCT FILES AND/OR DIRECTORIES OF YOUR RAILS APPLICATION.
BE SURE YOUR CHANGES ARE COMMITED OR BACKED UP!
  HEAD
  opts.separator "Possible types:"
  opts.separator "  resource: Replace resource name."
  opts.separator ""
  opts.separator "Supported SCM: git, svn"
  opts.separator ""
  opts.separator "OPTIONS:"
  opts.on("--skip-migration", "Don't generate table renaming migration files") {|v| options[:skip_migration] = v }
  opts.separator ""
  opts.separator "Examples:"
  opts.separator "  #{opts.program_name} resource user person"
end

begin
  opts.parse!
rescue OptionParser::InvalidOption
end

if ARGV.size != 3
  puts opts
  exit 1
end
type, from, to = ARGV

#== do
rename = RenameRefactoring.new(File.expand_path('.'), from, to)
rename.apply(options)
