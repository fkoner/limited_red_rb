AfterConfiguration do |config|
  unless ENV['STOP_RECORDING']
    require 'cukepatch'
    config.options[:formats] << ['CukePatch::Formatter::Stats', config.out_stream]
  
    cukepatch_config = CukePatch::Config.load_and_validate_config
    if cukepatch_config
      cuke_stats = CukePatch::Stats.new(cukepatch_config)
  
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
