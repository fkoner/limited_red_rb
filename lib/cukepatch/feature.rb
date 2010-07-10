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
        post("/project/#{@project_id}/build/#{build_id}/fail", :query => {:test => failure.file_colon_line})
      end

      def log_pass(build_id, pass)
        post("/project/#{@project_id}/build/#{build_id}/pass", :query => {:test => pass.file_colon_line})
      end

      def log_feature_data(build_id, json)
        post("/project/#{@project_id}/build/#{build_id}/data", {:features => json})
      end

      def find_failing_features
        raise "No project_id was found in params: #{params.inspect}" if @project_id.nil?
        response = get("/project/#{@project_id}/features/fail")
        return [] if response.nil? || response.empty?
        response.code == 200 ? response.body.split(" ") : []
      end

    end

  end
end
