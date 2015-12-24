def execute(cmd)
  puts cmd
  #system cmd
end

namespace :handy do

  desc "delete merged branches from github"
  task :delete_merged_branches_from_github do

    puts "This command deletes branches from github."
    puts "This command would never delete master, staging or production branch."
    puts "This command only deletes branches which are already merged."
    cmd = "git branch -r --merged | grep -v master | grep -v staging | grep -v production | sed -e 's/origin\//:/' | xargs git push origin"
    puts cmd

    `#{cmd}`
  end

  namespace :heroku do

    desc "Backup production database"
    task :backup_production, :app do |t, args|
      take_current_snapshot "#{heroku_app_name(t, args)}-production"
    end

    desc "Take snapshot of production db and copy production data to development"
    task :prod2development, :app do |t, args|
      puts "Execute following commands on your terminal"
      puts ""
      export2local "#{heroku_app_name(t, args)}-production"
    end

    desc "Take snapshot of staging db and copy staging data to development"
    task :staging2development, :app do |t, args|
      export2local "#{heroku_app_name(t, args)}-staging"
    end

    desc "Take snapshot of production db and copy production data to staging"
    task :prod2staging, :app do |t, args|
      take_current_snapshot "#{heroku_app_name(t, args)}-production"

      heroku_app_name = heroku_app_name(t, args)
      src_app_name = "#{heroku_app_name}-production"
      dst_app_name = "#{heroku_app_name}-staging"

      get_src_db_url_cmd = "`heroku pg:backups public-url --app #{src_app_name}`"
      execute "heroku pg:backups restore #{get_src_db_url_cmd} DATABASE --app #{dst_app_name} --confirm #{dst_app_name}"
    end

    desc "Take snapshot of branch A and copy data to branch B"
    task :a2b, :app do |t, args|
      a = ENV['A'] || ENV['a']
      b = ENV['B'] || ENV['b']

      if a.nil?
        puts "A was not supplied"
        puts "Usage: rake handy:heroku:a2b A=production B=533-home-page-design--ip"
        puts "       Also ensure that you have access to this application"
        exit 1
      end

      if b.nil?
        puts "B was not supplied"
        puts "Usage: rake handy:heroku:a2b A=production B=533-home-page-design--ip"
        exit 1
      end

      take_current_snapshot "#{heroku_app_name(t, args)}-#{a}"

      heroku_app_name = heroku_app_name(t, args)
      src_app_name = "#{heroku_app_name}-#{a}"
      dst_app_name = "#{heroku_app_name}-#{b}"

      get_src_db_url_cmd = "`heroku pg:backups public-url --app #{src_app_name}`"
      execute "heroku pg:backups restore #{get_src_db_url_cmd} DATABASE --app #{dst_app_name} --confirm #{dst_app_name}"
    end

    def export2local(app_name)
      take_current_snapshot(app_name)
      execute "curl -o latest.dump `heroku pg:backups public-url --app #{app_name}`"
      execute restore_command + "; rm latest.dump"
    end

    def take_current_snapshot(app_name)
      execute "heroku pg:backups capture --app #{app_name}"
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
      host = database_config[:host]

      #Posgresql.app sets user as machine user. In mac command "id -un" gets user name
      username = `id -un`.chomp

      result = "pg_restore --verbose --clean --no-acl --no-owner"
      result += " -h#{host}"
      result += " -U#{username}"
      result + " -d #{local_database} latest.dump"
    end
  end

end
