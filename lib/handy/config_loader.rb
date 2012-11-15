require "hashr"

module Handy
  class ConfigLoader

    attr_reader :filename

    def initialize(filename)
      @filename = filename
    end

    def load(key = Rails.env)
      file            = Rails.root.join('config', filename)
      return unless File.exist?(file)

      hash            = YAML.load(ERB.new(File.read(file)).result)

      common_hash = hash['common'] || {}
      env_hash = hash[key.to_s] || {}

      final_hash = common_hash.deep_merge(env_hash)
      ::Hashr.new(final_hash)
    end
  end
end
