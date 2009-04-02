require File.dirname(__FILE__) + '/spec_helper'

describe MigrationGenerator do

  before(:each) do
    @rails_root = File.expand_path(File.dirname(__FILE__) + '/../tmp')
    setup_temp_migration_folder(@rails_root)
    @generator = MigrationGenerator.new(@rails_root)
    @migration = @generator.generate_rename_table_migration('BlogPost', 'WeblogEntry')
  end

  it "should save the migration to RAILS_ROOT/db/migrate" do
    File.dirname(@migration.path).should == @rails_root + '/db/migrate'
  end

  it "should generae a filename of the format yyyymmddhhmmss_rename_blog_post_to_weblog_entry.rb" do
    File.basename(@migration.path).should =~ /^\d{14}_rename_blog_post_to_weblog_entry.rb$/
  end
  

  it "should generate a migration file to rename the models tables" do
    @migration.read.should == <<-eos
class RenameBlogPostToWeblogEntry < ActiveRecord::Migration
  def self.up
    rename_table :blog_posts, :weblog_entries
  end

  def self.down
    rename_table :weblog_entries, :blog_posts
  end
end
    eos
  end

  it "should handle namespaces in class names" do
    migration = @generator.generate_rename_table_migration('Foo::BlogPost', 'Bar::WeblogEntry')
    migration.read.should == <<-eos
class RenameFooBlogPostToBarWeblogEntry < ActiveRecord::Migration
  def self.up
    rename_table :blog_posts, :weblog_entries
  end

  def self.down
    rename_table :weblog_entries, :blog_posts
  end
end
    eos
  end
  
end
