namespace :handy do

  namespace :heroku do

    def ask(message)
      print message
       %w(y yes).include?  STDIN.gets.chomp.downcase
    end

    desc "Deletes herokou applications belonging to your account. Be very very careful. There is no going back."
    task :delete_apps do
      output = `heroku apps`
      output.split(/\r?\n/).each do |record|
        parts = record.split(' ')
        puts parts.join('/')
        name = parts.first
        cmd = "heroku apps:destroy --app #{name} --confirm #{name}"
        puts cmd
        if ask('This command is destructive, proceed? (yes, no): ')
          puts 'executing'
          system cmd
        end
        puts ''
        puts ''
      end
    end

  end
end
