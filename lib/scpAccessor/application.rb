require 'yaml'

module ScpAccessor
  class Application
    DefaultConfigurationFileLocation = "#{File.dirname(__FILE__)}/../../Conf/configuration.yaml"
    
    def initialize(output, configuration_file_location = DefaultConfigurationFileLocation)
      @output = output
      @configuration = read_configuration_file(configuration_file_location)
    end
    
    def start
      @output.puts 'Welcome to SCP Accessor!'
#      print_configuration_file
    end

    private

    def print_configuration_file
      @configuration.each_pair {|key, value|
        if value["active"] == true
          @output.puts "#{key} : #{value}"
        end
      }
    end

    def verify_file_content(configuration)
      missing = []
      configuration.each_pair {|key, value|

        next if value["active"] != nil and value["active"] == false

        missing << "active" if value["active"] == nil
        missing << "server" if value["server"] == nil
        missing << "user" if value["user"] == nil
        missing << "file_1" if value["file_1"] == nil
        missing << "out_dir" if value["out_dir"] == nil
        break if missing.size > 0
      }
      raise ("The following fields are mandatory: #{missing.join(',')}") if missing.size > 0
    end
    
    def read_configuration_file(configuration_file_location)
      #begin
      configuration = YAML.load_file(configuration_file_location)
      verify_file_content(configuration)
      @output.puts "Configuration file was loaded..."
      #rescue Errno::ENOENT => e
      #@output.puts "Spc Accessor wasn't able to find the file located in the Config folder."
      #abort
      #end
      
      configuration
    end
    
  end

end
