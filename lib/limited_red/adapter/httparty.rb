module LimitedRed
  module Adapter
    class HttParty
      def self.new(config, options = {})
        services = {}
        services['rspec'] = 'https://limited-red-unit-data-service.heroku.com/'
        services['cucumber'] = 'https://limited-red-data-service.heroku.com/'
        
        host = config['host'] || services[options['type']]
        port = config['port'] || ''
        uri = "#{host}#{port == '' ? '' : ":#{port}"}"
      
        HttPartyAdapter.base_uri(uri)
        HttPartyAdapter
      end
    end

    class HttPartyAdapter
      include HTTParty
      
      def self.encode_and_compress(data)
        compressed_result = Gzip.compress(data)
        Base64.encode64(compressed_result)
      end
      
    end
  end
end
