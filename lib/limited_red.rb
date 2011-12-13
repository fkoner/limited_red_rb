$:.unshift(File.dirname(__FILE__) + '/../lib') unless $:.include?(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'httparty'
require 'cucumber'

require 'limited_red/gzip'
require 'limited_red/feature'
require 'limited_red/thread_pool'
require 'limited_red/stats'
require 'limited_red/config'
require 'limited_red/formatter/stats'

module LimitedRed
end