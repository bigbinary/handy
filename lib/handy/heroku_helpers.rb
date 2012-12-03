def execute_command(cmd)
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

      puts cmd = "heroku pgbackups:restore DATABASE `heroku pgbackups:url --app #{src_app_name}` --app #{dst_app_name} --confirm #{dst_app_name}"
      execute_command cmd
    end


    def export2local(app_name)
      database = local_database

      puts cmd = "heroku pgbackups:capture --expire --app #{app_name}"
      execute_command cmd

      puts cmd = "curl -o latest.dump `heroku pgbackups:url --app #{app_name}`"
      execute_command cmd

      puts cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost  -U nsingh -d #{database} latest.dump"
      execute_command cmd

      puts cmd = "rm latest.dump"
      execute_command cmd
    end

    def heroku_app_name t, args
      args[:app] || ENV['APP_NAME'] || abort(<<ERROR_MSG)
Error: heroku app name is missing. This rake task should be invoked like this:

  rake #{t.name}['tweli'].
ERROR_MSG
    end

    def local_database
      database_config = Handy::ConfigLoader.new('database.yml').load
      database_config && database_config[:database] ||
          abort('Error: Please check your database.yml since no database was found.')
    end
  end

end
