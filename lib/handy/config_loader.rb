#This file is needed copy production db to localhost. This file
#is used to get database name.

require "hashr"

module Handy
  class ConfigLoader

    attr_reader :filename

    def initialize(filename)
      @filename = filename
    end

    def load(key = Rails.env)
      global_file = Rails.root.join('config', filename)
      settings = read_settings_from_file(global_file)
      common_settings = settings['common'] || {}
      env_settings = settings[key.to_s] || {}

      env_file = Rails.root.join('config', File.basename(filename, '.yml'), "#{key}.yml")

      env_settings_from_file = read_settings_from_file(env_file)
      env_settings = env_settings.deep_merge(env_settings_from_file)

      result_settings = common_settings.deep_merge(env_settings)
      ::Hashr.new(result_settings)
    end

    private
    def read_settings_from_file(filepath)
      return {} unless File.exist?(filepath)
      YAML.load(ERB.new(File.read(filepath)).result)
    end
  end
end
