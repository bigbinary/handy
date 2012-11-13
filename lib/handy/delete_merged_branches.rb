namespace :handy do

  namespace :git do

    def ask(message)
      print message
      STDIN.gets.chomp.downcase == 'yes'
    end

    desc "Delete merged branches."
    task :delete_merged_branches do
      puts 'Removing all REMOTE merged branches from repository'
      if ask('This command is destructive, proceed? (yes, no): ')
        sh "git branch -r --merged master | sed 's/ *origin\\///' | grep -v 'master$' | grep -v 'production$' | grep -v 'staging$' | xargs -I% git push origin :%"
        sh "git remote prune origin"
      end
    end

  end
end
