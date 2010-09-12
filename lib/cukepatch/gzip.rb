require 'zlib'
require 'stringio'

module CukePatch
  module Gzip
    class Stream < StringIO
      def close; rewind; end
    end

    def self.compress(source)
      output = Stream.new
      gz = Zlib::GzipWriter.new(output)
      gz.write(source)
      gz.close
      output.string
    end
    
    def self.decompress(source)
      Zlib::GzipReader.new(StringIO.new(source)).read
    end
  end
end