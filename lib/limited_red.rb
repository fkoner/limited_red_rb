$:.unshift(File.dirname(__FILE__) + '/../lib') unless $:.include?(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'httparty'

module LimitedRed
  ROOT = File.expand_path('..', __FILE__).to_s

  autoload :Gzip,           "#{ROOT}/limited_red/gzip"
  autoload :Client,         "#{ROOT}/limited_red/client"
  autoload :ThreadPool,     "#{ROOT}/limited_red/thread_pool"
  autoload :FakeThreadPool, "#{ROOT}/limited_red/thread_pool"
  autoload :Stats,          "#{ROOT}/limited_red/stats"
  autoload :Config,         "#{ROOT}/limited_red/config"
  autoload :Version,        "#{ROOT}/limited_red/version"

  module Adapter
    autoload :HttParty, "#{ROOT}/limited_red/adapter/httparty"
  end

  module Formatter
    autoload :Stats, "#{ROOT}/limited_red/formatter/stats"
  end
end