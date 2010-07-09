module CukePatch
  class Feature
    include HTTParty

    class << self
      def load_config(config = nil)
        config ||= YAML::load(IO.read(Dir.glob('{,.config/,config/}cukepatch{.yml,.yaml}').first))
        host = config['host'] || 'localhost'
        port = config['port'] || 9292
        @project_id = config['id']
        base_uri "#{host}:#{port}"
      end

      def log_fail(build_id, failure)
        post("/project/#{@project_id}/features/fail", :query => {:test => failure.file_colon_line, :id => build_id})
      end

      def log_pass(build_id, pass)
        post("/project/#{@project_id}/features/pass", :query => {:test => pass.file_colon_line, :id => build_id})
      end

      def log_feature_data(build_id, json)
        post("/project/#{@project_id}/build/data", {:features => json, :id => build_id})
      end

      def find_failing_features
        raise "No project_id was found in params: #{params.inspect}" if @project_id.nil?
        response = get("/project/#{@project_id}/features/failing")
        return [] if response.nil? || response.empty?
        response.code == 200 ? response.body.split(" ") : []
      end

    end

  end
end
