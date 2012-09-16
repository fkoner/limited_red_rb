module LimitedRed
  class Client
    def initialize(config, out = STDOUT, adapter = nil, thread_pool = ThreadPool)
      @config ||= config
      @out = out
      @username = @config['username']
      @api_key = @config['api key']
      @project_id = "#{@username}/#{@config['project name']}"
        
      @adapter = adapter || LimitedRed::Adapter::HttParty.new(@config)
      @thread_pool = thread_pool
    end

    def log_fail_result(build_id, data)
      log_result(build_id, data.merge(:pass => 'false'))
    end

    def log_pass_result(build_id, data)
      log_result(build_id, data.merge(:pass => 'true'))
    end

    def log_result(build_id, data)
      data[:result] = @adapter.encode_and_compress(data[:result])
      data = data.merge({:user => @username, 
                         :version => LimitedRed::Version::STRING,
                         :token => token_for(data.merge(:build_id => build_id))})

      @thread_pool.with_a_thread_run do
        response = @adapter.post("/{@project_id}/builds/#{build_id}/results", :body => data)
        log(response) if error?(response)
      end
    end

    def log_build(build_id, data)
      data[:build_id] = build_id
      data = data.merge({:user => @username, 
                         :version => LimitedRed::Version::STRING,
                         :build_id => build_id, :token => token_for(data)})
        
      @thread_pool.with_a_thread_run do
        response = @adapter.post("/#{@project_id}/builds", :body => data)
        log(response) if response && error?(response)
      end
    end
      
    def find_failing_features
      raise "No project name was found in params: #{@config.inspect}" if @project_id.nil?

      begin
        response = @adapter.get("/#{@project_id}/features/fails?user=#{@username}")
      rescue
        puts "[Limited Red] Unable to reach www.limited-red.com. No tests will be recorded."
        return []
      end

      if response.nil? || response.empty? || error?(response)
        return []
      else
        response.body.split(" ")
      end
    end
            
    private
    def token_for(data)
      data_string = @username.to_s +
                    @project_id.to_s +
                    (data[:uri] ?  data[:uri] : "") +
                    build_data_string(data[:fails]) +
                    build_data_string(data[:passes]) +
                    (data[:result] ? data[:result] : "") +
                    pass_string(data[:pass]) +
                    (data[:build_id].to_s) + 
                    LimitedRed::Version::STRING +
                    @api_key.to_s
      
      sha512 = Digest::SHA512.new
      digest = sha512.digest(data_string)
      Digest.hexencode(digest)
    end
    
    def pass_string(pass)
      if pass.nil?
        return ""
      else
        return pass
      end
    end

    def build_data_string(data)
      data == "" || data.nil? ? "" : data.join("")
    end

    def error?(response)
      response && response.code != 200
    end
    
    def log(response)
      @out.puts(error_message(response))
    end
      
    def error_message(response)
      "\nLimited Red had a problem logging your test results: #{response ? response.body : ''}"
    end
  end
end
