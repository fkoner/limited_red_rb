module LimitedRed
  class Stats
    def initialize(config)
      @client = Client.new(config)
    end

    def feature_files
      files = failing_features.uniq
      files.select{|file| File.exists?(file)}
    end

    private

    def failing_features
      @client.find_failing_features
    end 
  end
end