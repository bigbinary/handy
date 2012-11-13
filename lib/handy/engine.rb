module Handy
  class Engine < ::Rails::Engine

    rake_tasks do
      load 'handy/trailing_whitespaces.rb'
      load 'handy/delete_merged_branches.rb'
      load 'handy/heroku_helpers.rb'
    end

  end
end

