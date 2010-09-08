module CukePatch
  class Stats
    def initialize(config)
      Feature.load_config(config)
    end

    def feature_files
      files = failing_features.uniq
      files.select{|file| File.exists?(file)}
    end

    def failing_features
      CukePatch::Feature.find_failing_features
    end 
  end
end