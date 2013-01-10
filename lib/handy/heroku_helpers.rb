def execute(cmd)
  puts cmd
  system cmd
end

namespace :handy do

  namespace :heroku do
    desc "Copy production data to development"
    task :prod2development, :app do |t, args|
      export2local "#{heroku_app_name(t, args)}-production"
    end

    desc "Copy staging data to development"
    task :staging2development, :app do |t, args|
      export2local "#{heroku_app_name(t, args)}-staging"
    end

    desc "Copy production data to staging"
    task :prod2staging, :app do |t, args|
      heroku_app_name = heroku_app_name(t, args)
      src_app_name = "#{heroku_app_name}-production"
      dst_app_name = "#{heroku_app_name}-staging"

      get_src_db_url_cmd = "`heroku pgbackups:url --app #{src_app_name}`"
      execute "heroku pgbackups:restore DATABASE #{get_src_db_url_cmd} --app #{dst_app_name} --confirm #{dst_app_name}"
    end


    def export2local(app_name)
      execute "heroku pgbackups:capture --expire --app #{app_name}"
      execute "curl -o latest.dump `heroku pgbackups:url --app #{app_name}`"
      execute restore_command + "; rm latest.dump" 
    end

    def heroku_app_name t, args
      args[:app] || ENV['APP_NAME'] || Rails.root.basename || abort(<<ERROR_MSG)
Error: heroku app name is missing. This rake task should be invoked like this:

  rake #{t.name}['tweli'].
ERROR_MSG
    end

    def local_database
      database_config && database_config[:database] ||
          abort('Error: Please check your database.yml since no database was found.')
    end
    
    def database_config
      @database_config ||= Handy::ConfigLoader.new('database.yml').load
    end
    
    def restore_command
      result = "pg_restore --verbose --clean --no-acl --no-owner"
      result += " -h#{database_config[:host]}" if database_config[:host].present?
      result += " -U#{database_config[:username]}" if database_config[:username].present?
      result = "PGPASSWORD=#{database_config[:password]} #{result}" if database_config[:password].present?
      
      result + " -d #{local_database} latest.dump"
    end
  end

end
