module LimitedRed
  class Stats
    def initialize(config)
      @feature_logger = FeatureLogger.new(config)
    end

    def feature_files
      files = failing_features.uniq
      files.select{|file| File.exists?(file)}
    end

    def failing_features
      @feature_logger.find_failing_features
    end 
  end
end