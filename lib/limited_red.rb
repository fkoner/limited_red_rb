$:.unshift(File.dirname(__FILE__) + '/../lib') unless $:.include?(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'httparty'
require 'cucumber'

module LimitedRed
  ROOT = File.expand_path('..', __FILE__)

  autoload :Gzip,          "#{ROOT}/limited_red/gzip"
  autoload :HttParty,      "#{ROOT}/limited_red/httparty"
  autoload :FeatureLogger, "#{ROOT}/limited_red/feature_logger"
  autoload :ThreadPool,    "#{ROOT}/limited_red/thread_pool"
  autoload :Stats,         "#{ROOT}/limited_red/stats"
  autoload :Config,        "#{ROOT}/limited_red/config"

  module Formatter
    autoload :Stats, "#{ROOT}/limited_red/formatter/stats"
  end
end