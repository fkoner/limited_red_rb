module LimitedRed
  class FakeThreadPool
    class << self
      def with_a_thread_run(&block)
        yield
      end
      
      def wait_for_all_threads_to_finish
      end
    end
  end
  
  class ThreadPool
    class << self
      attr_writer :threads
      
      def with_a_thread_run(&block)
        @threads ||= []
        @threads << Thread.new(&block)
      end
      
      def wait_for_all_threads_to_finish
        @threads.each { |thread| thread.join }
      end
      
    end
  end
end