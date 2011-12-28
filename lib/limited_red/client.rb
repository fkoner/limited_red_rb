module LimitedRed
  class Client
    def initialize(config, out = STDOUT, adapter = nil, thread_pool = ThreadPool)
      @config ||= config
      @out = out
      @project_id = @config['project name']
      @username = @config['username']
      @api_key = @config['api key']
        
      @adapter = adapter || LimitedRed::Adapter::HttParty.new(@config)
      @thread_pool = thread_pool
    end

    def log_result(build_id, data)
      data[:result] = @adapter.encode_and_compress(data[:result])
      data = data.merge({:user => @username, 
                         :version => LimitedRed::Version::STRING,
                         :token => token_for(data.merge(:build_id => build_id))})

      @thread_pool.with_a_thread_run do
        result = @adapter.post("/projects/#{@project_id}/builds/#{build_id}/results", :body => data)
        @out.puts error_message(result) if error?(result)
      end
    end

    def log_build(build_id, data)
      data[:build_id] = build_id
      data = data.merge({:user => @username, 
                         :version => LimitedRed::Version::STRING,
                         :build_id => build_id, :token => token_for(data)})
        
      @thread_pool.with_a_thread_run do
        result = @adapter.post("/projects/#{@project_id}/builds", :body => data)
        @out.puts error_message(result) if error?(result)
      end
    end
      
    def find_failing_features
      raise "No project name was found in params: #{@config.inspect}" if @project_id.nil?

      response = @adapter.get("/projects/#{@project_id}/features/fails?user=#{@username}")

      return [] if response.nil? || response.empty?
      response.code == 200 ? response.body.split(" ") : []
    end
            
    private
    def token_for(data)
      data_string = @username.to_s +
                    @project_id.to_s +
                    build_data_string(data[:fails]) +
                    build_data_string(data[:passes]) +
                    (data[:result] ? data[:result] : "") +
                    (data[:build_id].to_s) + 
                    LimitedRed::Version::STRING +
                    @api_key.to_s

      Digest::SHA1.hexdigest(data_string)
    end

    def build_data_string(data)
      data == "" || data.nil? ? "" : data.join("")
    end

    def error?(result)
      result && !result.body.empty?
    end
      
    def error_message(error_msg)
      if (ENV['LIMITED_RED_ENV'] == 'test') || (ENV['LIMITED_RED_ENV'] == 'development')
        message = error_msg
      else
        message = ""
      end
      
      "\nLimited Red had a problem logging your test results.\n#{message}"
    end
  end
end
