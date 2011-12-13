CUKE_MAX_DIR = '../limited_red_server/bin'

desc "startup limited-red server for recording stats"
task :boot => [:kill_rack] do
  %x{#{CUKE_MAX_DIR}/cuke-max"}
  sleep(2)
end

task :kill_rack do
  begin
    %x{ps -ef | grep -v 'grep' | grep 'rackup' | awk '{print$2}' | xargs kill {}}
  rescue
  end
end