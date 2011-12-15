module LimitedRed
  class Stats
    def initialize(config)
      Client.load_config(config)
    end

    def feature_files
      files = failing_features.uniq
      files.select{|file| File.exists?(file)}
    end

    def failing_features
      Client.find_failing_features
    end 
  end
end