module LimitedRed
  module Adapter
    class HttParty
      def self.new(config, options = {})
        host = config['host'] || 'https://limited-red.heroku.com'
        port = config['port'] || ''
        uri = "#{host}#{port == '' ? '' : ":#{port}"}"
      
        Adapter.base_uri(uri)
        Adapter
      end
    end

    class HttPartyAdapter
      include HTTParty
      
      def encode_and_compress(data)
        compressed_result = Gzip.compress(data)
        Base64.encode(data)
      end
      
    end
  end
end