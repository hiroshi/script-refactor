require "find"
require "rubygems"
require "active_support"

require File.dirname(__FILE__) + '/migration_generator'

class RenameRefactoring

  def initialize(rails_root, from, to)
    @rails_root = rails_root
    @from = from
    @to = to
  end

  def apply(options={})
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
      "test/unit/#{@from}_test.rb" => "test/unit/#{@to}_test.rb",
      "test/functional/#{@from.pluralize}_controller_test.rb" => "test/functional/#{@to.pluralize}_controller_test.rb",
      "test/fixtures/#{@from.pluralize}.yml" => "test/fixtures/#{@to.pluralize}.yml",
      "app/views/#{@from.pluralize}" => "app/views/#{@to.pluralize}",
      "app/models/#{@from}.rb" => "app/models/#{@to}.rb",
      "app/helpers/#{@from.pluralize}_helper.rb" => "app/helpers/#{@to.pluralize}_helper.rb",
      "app/controllers/#{@from.pluralize}_controller.rb" => "app/controllers/#{@to.pluralize}_controller.rb",
    }

    puts "Renaming files and directories:"
    renames.each do |src, dst|
      if File.exist? src
        cmd = rename_cmd(src, dst)
        puts cmd
        `#{cmd}`
      end
    end

    puts "\nReplacing class and variables:"
    replaces = {
      @from => @to,
      @from.classify => @to.classify,
      @from.pluralize => @to.pluralize,
      @from.classify.pluralize => @to.classify.pluralize,
    }
    replaces.each do |f,t|
      puts "#{f} -> #{t}"
    end
    pattern = "(\\b|_)(#{replaces.keys.join("|")})(\\b|[_A-Z])"
    puts "pattern: /#{pattern}/"

    Find.find(".") do |path|
      # reject no source codes directories and SCM magic directories
      Find.prune if path =~ /((^\.\/(vendor|log|script|tmp|db))|\.(git|svn))$/

      if File.file? path
        content = File.read(path)
        # print replacing lines
        content.each_with_index do |line, idx|
          line.scan(/#{pattern}/).each do
            puts "#{path}:#{idx+1}: #{line}"
          end
        end

        replaced = content.gsub!(/#{pattern}/){ "#{$1}#{replaces[$2]}#{$3}"}
        unless replaced.nil?
          # replace file content
          open(path, "w") do |out|
            out.print content
          end
        end
      end
    end

    unless options[:skip_migration]
      puts 'generating rename migration'
      migraton_generator = MigrationGenerator.new(@rails_root)
      migraton_generator.generate_rename_table_migration(@from.camelize, @to.camelize)
    else
      puts 'SKIP: generating rename migration'
    end

    puts "\nNOTE: If you want to revert them:" if scm
    case scm
    when :git
      puts "  git reset --hard"
    when :svn
      puts "  svn revert -R ."
    end

  end

end
