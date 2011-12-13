module LimitedRed
  class Config
    class << self
      def load_and_validate_config
        ensure_config_exists
        if valid_config?
          config
        else
          errors = "Make sure you have the following set in your limited_red.yml:\n"
          errors += " * project name\n" unless config['project name']
          errors += " * username\n" unless config['username']
          errors += " * api key\n" unless config['api key']
          print errors
        end
      end

      def config
        @config ||= begin
          limited_red_project_config  = load_yaml(limited_red_project_config_file)
          limited_red_shared_config = load_yaml(limited_red_shared_config_file)
          limited_red_shared_config.merge(limited_red_project_config)
        end
      end

      private
      
      def load_yaml(file)
        if file
          content = IO.read(file)
          YAML::load(content)
        else
          {}
        end
      end

      def ensure_config_exists
        unless limited_red_project_config_file_exists?
          details = ask_for_setup_details
          
          File.open('#{home_dir}/.limited-red', 'w') do |f|
            f.write("username: #{details['username']}\n")
            f.write("api key: #{details['api key']}\n")
          end
          
          File.open('.limited_red.yml', 'w') do |f|
            f.write("project name: #{details['project name']}\n")
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

      def valid_config?
        config && 
        config['project name'] &&
        config['username'] &&
        config['api key']
      end

      def limited_red_project_config_file_exists?
        limited_red_project_config_file
      end

      def limited_red_shared_config_file
        @limited_red_file ||= Dir.glob("#{home_dir}/.limited_red").first
      end

      def limited_red_project_config_file
        @cukepatch_file ||= Dir.glob('{,.config/,config/}\.limited_red').first
      end
      
      private
      def home_dir
        ENV['HOME'] || File.expand_path('~')
      end
      
      def guess_project_name
        dir = Dir.pwd
        if dir
          current_dir = dir.split('/')[-1]
          return current_dir unless current_dir.empty?
        end
      end
    end
  end
end
