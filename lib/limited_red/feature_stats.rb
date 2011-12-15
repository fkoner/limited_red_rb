module LimitedRed
	class FeatureStats
    class << self
      def load_config(config, out = STDOUT)
        @config ||= config
        @out = out
        @project_id = @config['project name']
        @username = @config['username']
        
        @adapter = LimitedRed::HttParty.new(@config)
      end
        
      def find_failing_features
        raise "No project name was found in params: #{@config.inspect}" if @project_id.nil?

        response = @adapter.get("/projects/#{@project_id}/features/fails?user=#{@username}")

        return [] if response.nil? || response.empty?
        response.code == 200 ? response.body.split(" ") : []
      end
    end
	end
end