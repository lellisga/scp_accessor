require 'yaml'
require 'net/scp'

module ScpAccessor
  class Application
    DefaultConfigurationFileLocation = "#{File.dirname(__FILE__)}/../../Conf/configuration.yaml"
    
    def initialize(output, configuration_file_location = DefaultConfigurationFileLocation)
      @output = output
      @configuration = read_configuration_file(configuration_file_location)
    end
    
    def start
      @output.puts 'Welcome to SCP Accessor!'
      print_and_donwload_configuration_file
    end

    private

    def print_and_donwload_configuration_file
      @output.puts "These are the files that will be downloaded"
      @configuration.each_pair {|key, value|
        if value["active"] == true
          files = get_specific_value_from_a_particular_key(key,"file")
          @output.puts "#{files.join(', ')} from the #{value["server"]} server to the #{value["out_dir"]} path"
          download_files(files,value["server"], value["user"], value["password"], value["out_dir"])
        end
      }
    end

    def download_files(files, server, user, password, localPath)
      files.each do |file|
        Net::SCP.download!(server, user, file, localPath, :password => password)
      end
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
        missing << "password" if value["password"] == nil
        break if missing.size > 0
      }
      raise ("The following fields are mandatory: #{missing.join(',')}") if missing.size > 0
    end

    def get_specific_value_from_a_particular_key(key,value)
      files = []
      @configuration.each_pair{|iner_key, value|
        if iner_key == key
          value.keys.each do |k|
            if k =~ /(file_\d+)$/
              files << value["#{$1}"]
            end
          end
        end
      }
      files
    end
    
    def read_configuration_file(configuration_file_location)
      configuration = YAML.load_file(configuration_file_location)
      verify_file_content(configuration)
      @output.puts "Configuration file was loaded..."
      configuration
    end
  end

end
