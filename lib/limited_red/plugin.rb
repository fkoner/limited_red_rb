AfterConfiguration do |config|
  unless ENV['STOP_RECORDING']
    require 'limited_red'
  
    options = config.instance_variable_get("@options")
    options[:formats] << ['LimitedRed::Formatter::Stats', config.out_stream]
  
    limited_red_config = LimitedRed::Config.load_and_validate_config
    if limited_red_config
      cuke_stats = LimitedRed::Stats.new(limited_red_config)
  
      feature_files = options[:paths]
      feature_files = ["features"] if feature_files.empty?

      prioritised_features = cuke_stats.feature_files & config.feature_files
      
      options[:paths] = prioritised_features + feature_files
    else
      puts "Aborting Cucumber run"
      exit
    end
  end
end
