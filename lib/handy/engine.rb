module Handy
  class Engine < ::Rails::Engine

    rake_tasks do
      load 'handy/trailing_whitespaces.rb'
      load 'handy/delete_merged_branches.rb'
      load 'handy/heroku_tasks.rb'
      load 'handy/delete_heroku_apps.rb'
      load 'handy/add_database_yml.rb'
    end

  end
end
