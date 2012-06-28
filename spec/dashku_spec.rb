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

  describe "get_dashboards" do
    
    it "should return an array of dashboard objects" do
      dashku = Dashku.new
      dashku.set_api_key("c19cabb2-85d6-4be0-b1d6-d85a19b8245e")
      dashku.set_api_url("http://localhost")
      dashku.get_dashboards.class.should == Array
    end

    it "should throw an error if there is a problem" do
      dashku = Dashku.new
      dashku.set_api_key("waa")
      dashku.set_api_url("http://localhost")
      lambda{ dashku.get_dashboards }.should raise_error ApiKeyInvalidError
    end

  end

  describe "get_dashboard(id)" do
    
    it "should return a dashboard object" do
      dashku = Dashku.new
      dashku.set_api_key("c19cabb2-85d6-4be0-b1d6-d85a19b8245e")
      dashku.set_api_url("http://localhost")
      id = dashku.get_dashboards[0]["_id"]
      dashku.get_dashboard(id).class.should == Hash
    end

    it "should throw an error if there is a problem" do
      dashku = Dashku.new
      dashku.set_api_key("c19cabb2-85d6-4be0-b1d6-d85a19b8245e")
      dashku.set_api_url("http://localhost")
      lambda{ dashku.get_dashboard("waa") }.should raise_error DashboardNotFoundError
    end

  end

  describe "create_dashboard" do

    it "should return a dashboard object" do
      dashku = Dashku.new
      dashku.set_api_key("c19cabb2-85d6-4be0-b1d6-d85a19b8245e")
      dashku.set_api_url("http://localhost")
      dashboard_attrs     = {name: "King Bishmael"}
      req                 = dashku.create_dashboard(dashboard_attrs)
      req.class.should    == Hash
      req["name"].should  == dashboard_attrs[:name]
    end

    it "should throw an error if there is a problem" do
      dashku = Dashku.new
      dashku.set_api_key("waa")
      dashku.set_api_url("http://localhost")
      lambda{ dashku.create_dashboard({}) }.should raise_error ApiKeyInvalidError
    end

  end

end