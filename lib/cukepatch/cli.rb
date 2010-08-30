module CukePatch
  class Cli
    LANGUAGE = 'rb'
    CUKE_MAX_FORMATTER = "CukePatch::Formatter::Stats"

    class << self
      def run(args)
        runner = cukepatch(args)
        runner.run if runner
      end
      
      def cukepatch(args)
        ensure_config_exists
        if valid_config?(config)
          new(args, config)
        else
          errors = "Make sure you have the following set in your cukepatch.yml:\n"
          errors += " * project name\n" unless config['project name']
          errors += " * username\n" unless config['username']
          errors += " * api key\n" unless config['api key']
          print errors
        end
      end

      private

      def ensure_config_exists
        unless cukepatch_yml_defined?
          details = ask_for_setup_details
          File.open('cukepatch.yml', 'w') do |f|
            f.write("project name: #{details['project name']}\n")
            f.write("username: #{details['username']}\n")
            f.write("api key: #{details['api key']}\n")
          end
        end
      end

      def ask_for_setup_details
        details = {}
        print "Project name"
        project_name = guess_project_name
        print " (default: #{project_name})" if project_name
        print ": "
        name = STDIN.readline.strip
        name = name.empty? ? project_name : name
        name.downcase
        details['project name'] = name.gsub(/[^a-zA-Z0-9']+/, "-")
        print "username: "
        username = STDIN.readline.strip
        details['username'] = username
        print "api key: "
        api_key = STDIN.readline.strip
        details['api key'] = api_key
        details
      end

      def valid_config?(config)
        config && 
        config['project name'] &&
        config['username'] &&
        config['api key']
      end

      def cukepatch_yml_defined?
        cukepatch_file
      end

      def config
        @config ||= YAML::load(IO.read(cukepatch_file))
      end

      def cukepatch_file
        @cukepatch_file ||= Dir.glob('{,.config/,config/}cukepatch{.yml,.yaml}').first
      end
      
      private
      def guess_project_name
        dir = Dir.pwd
        if dir
          current_dir = dir.split('/')[-1]
          return current_dir unless current_dir.empty?
        end
      end
    end

    def initialize(args, config)
      @args = args || []
      @config = config
    end

    def run
      run_cucumber_with(extended_args)
    end

    def extended_args
      extend_for_cukepatch(prioritied_features)
    end

    def extend_for_cukepatch(prioritised_features)
      formatter_options = ["--format", CUKE_MAX_FORMATTER,
                           "--out", ".cukepatch.tmp"]

      formatter_options += ["--format", "pretty"] unless default_formatter_overriden?

      prioritised_features + formatter_options + @args
    end
        
    private

    def prioritied_features
      cuke_stats = CukePatch::Stats.new(@args, @config)
      cuke_stats.feature_files
    end

    def run_cucumber_with(args)
      step_mother = ::Cucumber::StepMother.new
      step_mother.load_programming_language(LANGUAGE)
      ::Cucumber::Cli::Main.new(args).execute!(step_mother)
    end

    def default_formatter_overriden?
      @args.include?("--format") || @args.include?("-f")
    end

  end
end
