module Handy
  class Engine < ::Rails::Engine

    initializer :load_application_yml, before: :load_environment_config do
      settings_file = Rails.root.join('config', 'settings.yml')
      if File.exist?(settings_file)
        ::Settings = ConfigLoader.new('settings.yml').load
      end
    end

    rake_tasks do
      load 'handy/trailing_whitespaces.rb'
      load 'handy/delete_merged_branches.rb'
      load 'handy/heroku_tasks.rb'
      load 'handy/delete_heroku_apps.rb'
      load 'handy/add_database_yml.rb'
    end

  end
end
