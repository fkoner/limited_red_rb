module LimitedRed
  class HttParty
    def self.new(config, options = {})
      host = config['host'] || 'https://limited-red.heroku.com'
      port = config['port'] || ''
      uri = "#{host}#{port == '' ? '' : ":#{port}"}"
      
      Adapter.base_uri(uri)
      Adapter
    end
  end

  class Adapter
    include HTTParty
  end
end