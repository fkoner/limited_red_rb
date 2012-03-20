require 'json'

module LimitedRed
  module Rspec
    class Metadata
      def initialize(metadata)
        @metadata = metadata
      end
    
      def to_json
        {:file => file, 
         :line => line, 
         :uri =>  uri,
         :pretty_name => full_description,
         :scopes => scopes}.to_json
      end

      def file_and_line
        "#{file}:#{line}"
      end
      
      private
    
      def uri
        scopes.map{|s| s.to_s.downcase.gsub(/\s+/, '-')}.join("-")
      end
    
      def full_description
        @metadata[:full_description]
      end
    
      def file
        file = @metadata[:file_path]
        file = file.gsub("#{Dir.pwd}/", '')
        file
      end

      def line
        @metadata[:line_number]
      end
      
      def scopes
        extract_scopes_from(@metadata)
      end
      
      def extract_scopes_from(metadata)
        if metadata.has_key?(:example_group)
          extract_scopes_from(metadata[:example_group]) + metadata[:description_args]
        else
          metadata[:description_args]
        end
      end
    
    end
  end
end