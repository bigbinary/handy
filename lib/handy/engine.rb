module Handy
  class Engine < ::Rails::Engine

    initializer :load_application_yml, before: :load_environment_config do
      ::Settings = ConfigLoader.new('settings.yml').load
    end

    initializer :setup_formatter, after: :initialize_logger do
      begin
        if Rails.logger.respond_to?(:formatter=)
          Rails.logger.formatter = SimpleFormatter.new
        elsif Rails.version < "4.0"
          Rails.logger.instance_variable_get(:@logger)
          .instance_variable_get(:@log)
          .formatter = SimpleFormatter.new
        end
      rescue
        #do nothing
      end
    end

    rake_tasks do
      load 'handy/trailing_whitespaces.rb'
      load 'handy/delete_merged_branches.rb'
      load 'handy/heroku_tasks.rb'
      load 'handy/delete_heroku_apps.rb'
    end

  end
end

