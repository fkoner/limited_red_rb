module CukePatch
  class Feature
    include HTTParty

    class << self
      def load_config(config = nil)
        @config ||= YAML::load(IO.read(Dir.glob('{,.config/,config/}cukepatch{.yml,.yaml}').first))
        host = @config['host'] || 'www.cukemax.com'
        port = @config['port'] || 80

        @project_id = @config['project name']
        @username = @config['username']
        @api_key = @config['api key']
        base_uri "#{host}:#{port}"
      end

      def log_results(build_id, data)
        post("/projects/#{@project_id}/builds", :body => data.merge({:user => @username,
                                                                     :token => @api_key}))
      end

      def find_failing_features
        raise "No project name was found in params: #{@config.inspect}" if @project_id.nil?
        response = get("/projects/#{@project_id}/features/fails")

        return [] if response.nil? || response.empty?
        response.code == 200 ? response.body.split(" ") : []
      end

    end

  end
end
