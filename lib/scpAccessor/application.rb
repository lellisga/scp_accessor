require 'yaml'

module ScpAccessor
  class Application

    attr_accessor :configuration
    
    def initialize(output)
      @output = output
      read_configuration_file
    end
    
    def start
      @output.puts 'Welcome to SCP Accessor!'
    end

    private
    
    def read_configuration_file
      begin
        @configuration = YAML.load_file("#{File.dirname(__FILE__)}/../../Conf/configuration.yaml")
        @output.puts "Configuration file was loaded..."
      rescue Errno::ENOENT
        @output.puts "SpcAccessor wasn't able to find the file located in the Config folder"
      end
      

      
    end
    
  end
end
