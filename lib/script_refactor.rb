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

  resource: Replace resouce name.

Examples:
  #{$0} resource user person

  USAGE
  exit 1
end

# main
require "find"
require "rubygems"
require "activesupport"

# arguments
type, from, to = ARGV
# scm
case
when File.directory?(".git")
  scm = :git
  def rename_cmd(src, dst); "git mv #{src} #{dst}"; end
when File.directory?(".svn")
  scm = :svn
  def rename_cmd(src, dst); "svn mv #{src} #{dst}"; end
else
  def rename_cmd(src, dst); "mv #{src} #{dst}"; end
end

renames = {
  "test/unit/#{from}_test.rb" => "test/unit/#{to}_test.rb",
  "test/functional/#{from.pluralize}_controller_test.rb" => "test/functional/#{to.pluralize}_controller_test.rb",
  "test/fixtures/#{from.pluralize}.yml" => "test/fixtures/#{to.pluralize}.yml",
  "app/views/#{from.pluralize}" => "app/views/#{to.pluralize}",
  "app/models/#{from}.rb" => "app/models/#{to}.rb",
  "app/helpers/#{from.pluralize}_helper.rb" => "app/helpers/#{to.pluralize}_helper.rb",
  "app/controllers/#{from.pluralize}_controller.rb" => "app/controllers/#{to.pluralize}_controller.rb",
}

puts "Renamming files and directories:"
renames.each do |src, dst|
  cmd = rename_cmd(src, dst)
  if File.exist? src
    puts cmd
    `#{cmd}`
  end
end

puts "\nReplacing class and variables:"
replaces = {
  from => to,
  from.classify => to.classify,
  from.pluralize => to.pluralize,
  from.classify.pluralize => to.classify.pluralize,
}
replaces.each do |f,t|
  puts "#{f} -> #{t}"
end
pattern = "(\\b|_)(#{replaces.keys.join("|")})(\\b|[_A-Z])"
puts "pettern: /#{pattern}/"
puts ""

Find.find(".") do |path|
  Find.prune if path =~ /\/(vendor|log|script|tmp|\.(git|\.svn))$/

  if File.file? path
    input = File.read(path)
    # print replacing lines
    input.each_with_index do |line, idx|
      line.scan(/#{pattern}/).each do
        puts "#{path}:#{idx+1}: #{line}"
      end
    end
    # replace file content
    open(path, "w") do |out|
      out.print input.gsub(/#{pattern}/){ "#{$1}#{replaces[$2]}#{$3}"}
    end
  end
end

puts "\nNOTE: If you want to revert them:" if scm
case scm
when :git
  puts "  git reset --hard"
when :svn
  puts "  svn revert -R ."
end
