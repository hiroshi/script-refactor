require File.dirname(__FILE__) + '/../lib/migration_generator'

def setup_temp_migration_folder(rails_root)
  FileUtils.rm_rf(rails_root) if File.exists?(rails_root)
  FileUtils.mkdir_p(rails_root + '/db/migrate')
end
