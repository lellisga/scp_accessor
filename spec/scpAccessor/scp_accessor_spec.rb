require 'spec_helper'

module ScpAccessor
  describe Application do

    let(:output){double('output').as_null_object}
    let(:application){Application.new(output,"#{File.dirname(__FILE__)}/../../Conf/configuration_example.yaml")}
    
    context "Loading the YAML file" do

      describe "#read_configuration_file" do
        it "should read the YALM file without no problems" do
          output.should_not_receive(:puts).with(/SpcAccessor wasn't able to find the file/)
          output.should_receive(:puts).with(/Configuration file was loaded.../)
          application.start
        end
        
        it "should raise an error because the file doesn't exists" do
          lambda{Application.new(output,"#{File.dirname(__FILE__)}/../../Conf/configuration_example_dont_Exist.yaml")}.should \
          raise_error(Errno::ENOENT)
        end
      end
      
      context "Verifying the content of the file" do
        describe "#verify_file_content" do
          it "should load the configuration file without no problem" do
            output.should_receive(:puts).with(/Configuration file was loaded.../)
            application.start
          end
          
          it "should raise a MissingField Error when a field is missing" do
            lambda{ Application.new(output,"#{File.dirname(__FILE__)}/../../Conf/configuration_example_2.yaml")}.should \
            raise_error(/The following fields are mandatory:/)
          end
        end
      end
    end
    
    context "Starting the application" do
      describe "#start" do
        it "sends a welcome message" do
          output.should_receive(:puts).with('Welcome to SCP Accessor!')
          application.start
        end
      end
    end
    
      
  end
end
