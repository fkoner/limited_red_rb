module LimitedRed
  class Config
    def initialize(out_stream = STDOUT, in_stream = STDIN, env_config = ENV)
      @in = in_stream
      @out = out_stream
      @env_config = env_config
    end
    
    def self.load_and_validate_config(type)
      new.load_and_validate_config(type)
    end
        
    def load_and_validate_config(type)
      ensure_config_exists
      if valid_config?
        config.merge({'type' => type})
      else
        errors = "Make sure you have the following set in your .limited_red:\n"
        errors += " * project name\n" unless config['project name']
        errors += " * username\n" unless config['username']
        errors += " * api key\n" unless config['api key']
        @out.print errors
      end
    end

    def config
      @config ||= begin
        limited_red_project_config  = load_yaml(limited_red_project_config_file)
        limited_red_shared_config = load_yaml(limited_red_shared_config_file)

        limited_red_shared_config = limited_red_shared_config.merge(limited_red_project_config)

        if @env_config.has_key?('LIMITED_RED_USERNAME')
          limited_red_shared_config = limited_red_shared_config.merge({'username' => @env_config['LIMITED_RED_USERNAME']})
        end

        if @env_config.has_key?('LIMITED_RED_API_KEY')
          limited_red_shared_config = limited_red_shared_config.merge({'api key' => @env_config['LIMITED_RED_API_KEY']})
        end
        limited_red_shared_config
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
      return if @env_config['LIMITED_RED_API_KEY']

      unless limited_red_project_config_file_exists?
        details = ask_for_setup_details

        File.open("#{home_dir}/.limited_red", 'w') do |f|
          f.write("username: #{details['username']}\n")
          f.write("api key: #{details['api key']}\n")
        end
          
        FileUtils.touch(".limited_red")
        File.open('.limited_red', 'w') do |f|
          f.write("project name: #{details['project name']}\n")
        end
      end
    end

    def ask_for_setup_details
      details = {}
      @out.print "Project name"
      project_name = guess_project_name
      @out.print " (default: #{project_name})" if project_name
      @out.print ": "
      name = @in.readline.strip
      name = name.empty? ? project_name : name
      name.downcase
      details['project name'] = name.gsub(/[^a-zA-Z0-9']+/, "-")
      @out.print "username: "
      username = @in.readline.strip
      details['username'] = username
      @out.print "api key: "
      api_key = @in.readline.strip
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
      @global_config_file ||= Dir.glob("#{home_dir}/.limited_red").first
    end

    def limited_red_project_config_file
      @project_config_file ||= Dir.glob('.limited_red').first
    end
      
    private
    def home_dir
      ENV['HOME'] ||  File.expand_path('~').to_s #Dir.home
    end
      
    def guess_project_name
      dir = Dir.pwd
      if dir
        current_dir = dir.split('/')[-1]
        return current_dir if current_dir && !current_dir.empty?
      end
    end
  end
end
