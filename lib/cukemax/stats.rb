module CukeMax
  class Stats
    def initialize(args, config)
      @args = args
      Feature.load_config(config)
    end

    def feature_files
      files = failing_features.uniq
      files.select{|file| File.exists?(file)}
    end

    def failing_features
      CukeMax::Feature.find_failing_features
    end
 
    def arguments
      @args.join(" ")
    end
  end
end