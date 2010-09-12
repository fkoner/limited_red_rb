$:.unshift(File.dirname(__FILE__) + '/../lib') unless $:.include?(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
gem 'httparty', '=0.5.2'
require 'httparty'
require 'cucumber'

require 'cukepatch/gzip'
require 'cukepatch/feature'
require 'cukepatch/thread_pool'
require 'cukepatch/stats'
require 'cukepatch/config'
require 'cukepatch/formatter/stats'

module CukePatch
end