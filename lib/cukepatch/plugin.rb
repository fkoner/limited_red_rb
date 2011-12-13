AfterConfiguration do |config|
  unless ENV['STOP_RECORDING']
    require 'limited_red'
    config.options[:formats] << ['LimitedRed::Formatter::Stats', config.out_stream]
  
    cukepatch_config = LimitedRed::Config.load_and_validate_config
    if cukepatch_config
      cuke_stats = LimitedRed::Stats.new(cukepatch_config)
  
      feature_files = config.options[:paths]
      feature_files = ["features"] if feature_files.empty?

      prioritised_features = cuke_stats.feature_files & config.feature_files
      
      config.options[:paths] = prioritised_features + feature_files
    else
      puts "Aborting Cucumber run"
      exit
    end
  end
end
