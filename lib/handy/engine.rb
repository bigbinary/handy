module Handy
  class Engine < ::Rails::Engine

    initializer :load_application_yml, before: :load_environment_config do
      ::Settings = ConfigLoader.new('settings.yml').load
    end

    rake_tasks do
      load 'handy/trailing_whitespaces.rb'
      load 'handy/delete_merged_branches.rb'
      load 'handy/heroku_tasks.rb'
      load 'handy/add_services_and_workers_to_test.rb'
      load 'handy/delete_heroku_apps.rb'
    end

  end
end

