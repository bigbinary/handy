namespace :handy do

  def git_branch_command
    "git_branch = `git symbolic-ref HEAD 2>/dev/null`.chomp.sub('refs/heads/', '')"
  end

  def repository_name_command
    "repository_name = `git rev-parse --show-toplevel`.split('/').last.strip"
  end

  def database_name(env)
    case env
    when 'development'
      '<%= "#{repository_name}_development"[0...63] %>'
    when 'test'
      '<%= "#{repository_name}_test"[0...63] %>'
    end
  end

  def database_yml_path
    File.join Rails.root, 'config', 'database.yml'
  end

  def adapter
    ENV['ADAPTER'] = 'mysql2' if ENV['ADAPTER'] == 'mysql'
    @_adapter ||= ENV['ADAPTER'] || 'postgresql'
  end

  def adapter_credentials
    case adapter
    when 'postgresql'
      { 'username' => 'postgres', 'password' => nil }
    when 'sqlite3'
      {}
    when 'mysql2'
      { 'username' => 'root', 'password' => nil }
    else
      raise "Adapter #{adapter} is not supported."
    end
  end

  def db_character_set
    case adapter
    when 'postgresql'
      'unicode'
    when 'sqlite3'
      nil
    when 'mysql', 'mysql2'
      'utf8'
    else
      raise "Adapter #{adapter} is not supported."
    end
  end

  def config(env)
    { env => { 'adapter'  => adapter,
               'database' => database_name(env),
               'encoding' => db_character_set,
               'host'     => 'localhost',
               'pool'     => 5
             }.merge(adapter_credentials)
    }
  end

  desc 'Creates database.yml. Default adapter is postgresql. Uses repository name and environment for generating database name. Options: (ADAPTER: sqlite3/mysql2/postgresql)'
  task :add_database_yml do
    File.open database_yml_path, 'w' do |f|
      f.write "<% #{git_branch_command} %>\n"
      f.write "<% #{repository_name_command} %>\n"
      f.write "\n"
      f.write "# Database name is restricted to 63 characters.\n"
      f.write "# Because the default limit on length of identifiers in PostGreSQL is 63.\n"
      f.write "\n"
      f.write config('development').to_yaml.gsub(/^---\s+/, '')
      f.write "\n"
      f.write config('test').to_yaml.gsub(/^---\s+/, '')
    end
  end
end
