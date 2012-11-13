namespace :handy do

  namespace :heroku do

    desc "Copy production data to development"
    task :prod2development do
      cmd = "heroku pgbackups:capture --expire --app tweli-production"
      system(cmd)

      cmd = "curl -o latest.dump `heroku pgbackups:url --app tweli-production`"
      system(cmd)

      cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost  -U nsingh -d tweli_development latest.dump"
      system(cmd)

      cmd = "rm latest.dump"
      system(cmd)
    end

    desc "Copy staging data to development"
    task :staging2development do
      cmd = "heroku pgbackups:capture --expire --app tweli-staging"
      system(cmd)

      cmd = "curl -o latest.dump `heroku pgbackups:url --app tweli-staging`"
      system(cmd)

      cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost  -U nsingh -d tweli_development latest.dump"
      system(cmd)

      cmd = "rm latest.dump"
      system(cmd)
    end

  end
end
