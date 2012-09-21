AfterConfiguration do |config|
  if ENV['LIMITED_RED'] || ENV['LIMITED_RED_API_KEY']
    require 'limited_red'
  
    limited_red_config = LimitedRed::Config.load_and_validate_config('cucumber')
    if limited_red_config
      options = config.instance_variable_get("@options")
      options[:formats] << ['LimitedRed::Cucumber::Formatter::Stats', config.out_stream]
      
      cuke_stats = LimitedRed::Stats.new(limited_red_config)
  
      feature_files = options[:paths]
      feature_files = ["features"] if feature_files.empty?

      prioritised_features = cuke_stats.feature_files & config.feature_files
      
      options[:paths] = prioritised_features + feature_files
    else
      puts "Warning: Limited Red unable to load"
    end
  end
end
