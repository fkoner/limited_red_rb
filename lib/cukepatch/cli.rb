module CukePatch
  class Cli
    LANGUAGE = 'rb'
    CUKE_MAX_FORMATTER = "CukePatch::Formatter::Stats"

    class << self
      def run(args)
        cukepatch(args).run
      end
      
      def cukepatch(args)
        ensure_config_exists
        if valid_config?(config)
          new(args, config)
        else
          puts "Please set the id in your cukepatch.yml."
        end
      end

      private

      def ensure_config_exists
        unless cukepatch_yml_defined?
          project_name = ask_for_project_name
          File.open('cukepatch.yml', 'w') do |f|
            f.write("id: #{project_name}")
          end
        end
      end

      def ask_for_project_name
        print "Project name"
        project_name = guess_project_name
        print " (default: #{project_name})" if project_name
        print ": "
        input = STDIN.readline.strip
        input = input.empty? ? project_name : input
        input.downcase
        input.gsub(/[^a-zA-Z0-9']+/, "-")
      end

      def valid_config?(config)
        config && config['id']
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
