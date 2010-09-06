AfterConfiguration do |config|
  require 'cukemax'
  config.options[:formats] << ['CukeMax::Formatter::Stats', config.out_stream]
  
  cukemax_config = CukeMax::Cli.load_and_validate_config
  if cukemax_config
    cuke_stats = CukeMax::Stats.new(cukemax_config)
  
    feature_files = config.options[:paths]
    feature_files = ["features"] if feature_files.empty? 
    config.options[:paths] = cuke_stats.feature_files + feature_files
  else
    put "Aborting Cucumber run"
    exit
  end
end
