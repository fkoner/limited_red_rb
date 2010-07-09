CUKE_MAX_DIR = '../cuke-max/bin'

desc "startup cukepatch server for recording stats"
task :boot => [:kill_rack] do
  require 'rubygems'
  require 'ruby-debug'
  debugger
  sh "#{CUKE_MAX_DIR}/cuke-max"
  sleep(2)
end

task :kill_rack do
  begin
    sh "ps -ef | grep -v 'grep' | grep 'rackup' | awk '{print$2}' | xargs kill {}"
  rescue
  end
end