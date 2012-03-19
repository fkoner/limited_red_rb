require 'rspec'
require 'fakeweb'

$:.unshift(File.dirname(__FILE__) + '/../lib') unless $:.include?(File.dirname(__FILE__) + '/../../lib')

#Use local plugin
require 'limited_red'
require 'limited_red/plugins/rspec'

FakeWeb.allow_net_connect = false
