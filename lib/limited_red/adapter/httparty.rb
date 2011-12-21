module LimitedRed
  module Adapter
    class HttParty
      def self.new(config, options = {})
        host = config['host'] || 'https://limited-red.heroku.com'
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