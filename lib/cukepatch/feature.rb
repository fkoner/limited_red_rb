module CukePatch
  class Feature
    include HTTParty

    class << self
      def load_config(config = nil)
        @config ||= Config.config
        host = @config['host'] || 'https://limited-red.heroku.com'
        port = @config['port'] || ''

        @project_id = @config['project name']
        @username = @config['username']
        @api_key = @config['api key']
        base_uri "#{host}#{port == '' ? '' : ":#{port}"}"
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
        data_string = @username.to_s +
                      @project_id.to_s +
                      build_data_string(data[:fails]) +
                      build_data_string(data[:passes]) +
                      data[:features] +
                      @api_key.to_s

        Digest::SHA1.hexdigest(data_string)
      end

      def build_data_string(data)
        data == "" ? "" : data.join("")
      end

      def error?(result)
        result && !result.body.empty?
      end
      
      def error_message(error_msg)
        "\nCukePatch had a problem logging your test results.\n  #{error_msg}\n\n"
      end

    end

  end
end
