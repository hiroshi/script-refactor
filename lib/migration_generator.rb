require 'active_support'

class MigrationGenerator

  @rails_root
  def initialize(rails_root)
    @rails_root = rails_root
  end

  def generate_rename_table_migration(old_class_name, new_class_name)

    migration_content = File.read(File.dirname(__FILE__) + '/rename_migration_template.rb')

    to_replace = {
      'migration_name' => migration_name(old_class_name, new_class_name),
      'old_table_name' => table_name(old_class_name),
      'new_table_name' => table_name(new_class_name)
    }
    to_replace.each do |key, value|
      migration_content.gsub!("{#{key}}", value)
    end

    file_name = "#{@rails_root}/db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{to_replace['migration_name'].underscore}.rb"
    open(file_name, "w") do |out|
      out.print migration_content
    end
    return File.new(file_name)
  end

  private

  def migration_name(old_class_name, new_class_name)
    "Rename#{remove_namepsace_delim(old_class_name)}To#{remove_namepsace_delim(new_class_name)}"
  end
  
  def remove_namepsace_delim(value)
    value.sub('::', '')
  end

  def table_name(value)
    value.gsub(/.*::/, '').underscore.pluralize
  end

    
end
