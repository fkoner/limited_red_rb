module CukeMax
  class Feature
    include HTTParty

    class << self
      def load_config(config = nil)
        @config ||= YAML::load(IO.read(Dir.glob('{,.config/,config/}cukemax{.yml,.yaml}').first))
        host = @config['host'] || 'https://cukemax.heroku.com'
        port = @config['port'] || 80

        @project_id = @config['project name']
        @username = @config['username']
        @api_key = @config['api key']
        base_uri "https://cukemax.heroku.com"
      end

      def log_results(build_id, data)
        result = post("/projects/#{@project_id}/builds", :body => data.merge({:user => @username,
                                                                              :token => token_for(data)}))

        puts error_message(result) if error?(result)
      end

      def find_failing_features
        raise "No project name was found in params: #{@config.inspect}" if @project_id.nil?
        response = get("/projects/#{@project_id}/features/fails?user=#{@username}")

        return [] if response.nil? || response.empty?
        response.code == 200 ? response.body.split(" ") : []
      end
      
      private
      def token_for(data)
        data_string = @username +
                      @project_id.to_s +
                      data[:fails].join("") +
                      data[:passes].join("") +
                      data[:features] +
                      @api_key

        Digest::SHA1.hexdigest(data_string)
      end

      def error?(result)
        result && !result.body.empty?
      end
      
      def error_message(error_msg)
        "\nCukeMax had a problem logging your test results.\n  #{error_msg}\n\n"
      end

    end

  end
end
