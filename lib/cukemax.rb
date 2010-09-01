$:.unshift(File.dirname(__FILE__) + '/../lib') unless $:.include?(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
gem 'httparty', '=0.5.2'
require 'httparty'
require 'cucumber'

require 'cukemax/feature'
require 'cukemax/stats'
require 'cukemax/cli'
require 'cukemax/formatter/stats'

module CukeMax
end