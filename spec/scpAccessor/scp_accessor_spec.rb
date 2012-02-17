require 'spec_helper'

module ScpAccessor
  describe Application do

    let(:output){double('output').as_null_object}
    let(:application){Application.new(output)}
    
    context "Loading the YAML file" do
      it "should load for the YALM file" do
        output.should_not_receive(:puts).with(/SpcAccessor wasn't able to find the file/)
        output.should_receive(:puts).with(/Configuration file was loaded.../)
        application.start
      end
      
      it "should print the configuration"
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
