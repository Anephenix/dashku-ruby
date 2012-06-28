require 'dashku'

describe Dashku do

  describe "set_api_key" do

    it "should set the api key for dashku" do      
      dashku = Dashku.new
      dashku.set_api_key("waaa")
      dashku.api_key.should == "waaa"
    end

  end

  describe "api_url" do
    
    it "should return the api url" do
      dashku = Dashku.new
      dashku.api_url.should == "http://176.58.100.203"
    end

  end

  describe "set_api_url" do

    it "should set the api url" do
      dashku = Dashku.new
      dashku.set_api_url("http://waaa")
      dashku.api_url.should == "http://waaa"
    end

  end

end