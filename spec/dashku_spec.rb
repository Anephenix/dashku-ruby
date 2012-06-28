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

  describe "update_dashboard" do

    it "should return a dashboard object" do
      dashku = Dashku.new
      dashku.set_api_key("c19cabb2-85d6-4be0-b1d6-d85a19b8245e")
      dashku.set_api_url("http://localhost")
      dashboard = dashku.get_dashboards.select { |d| d["name"] == "King Bishmael" }
      dashboard = dashboard[0]
      dashboard["screenWidth"]    = "fluid"
      req                         = dashku.update_dashboard(dashboard)
      req.class.should            == Hash
      req["screenWidth"].should   == dashboard["screenWidth"]
    end

    it "should throw an error if there is a problem" do
      dashku = Dashku.new
      dashku.set_api_key("c19cabb2-85d6-4be0-b1d6-d85a19b8245e")
      dashku.set_api_url("http://localhost")
      lambda {
        dashku.update_dashboard({"screenWidth" => "fluid"})
      }.should raise_error MissingIdError
    end

  end

  describe "delete_dashboard" do

    it "should return the id of the deleted dashboard" do
      dashku = Dashku.new
      dashku.set_api_key("c19cabb2-85d6-4be0-b1d6-d85a19b8245e")
      dashku.set_api_url("http://localhost")
      dashboard = dashku.get_dashboards.select { |d| d["name"] == "King Bishmael" }
      dashboard = dashboard[0]
      dashku.delete_dashboard(dashboard["_id"])["dashboardId"].should == dashboard["_id"]            
    end

    it "should throw an error if there is a problem" do
      dashku = Dashku.new
      dashku.set_api_key("c19cabb2-85d6-4be0-b1d6-d85a19b8245e")
      dashku.set_api_url("http://localhost")
      lambda {
        dashku.delete_dashboard("waa")
      }.should raise_error DashboardNotFoundError
    end

  end

  describe "create_widget" do

    it "should return the widget object" do
      dashku = Dashku.new
      dashku.set_api_key("c19cabb2-85d6-4be0-b1d6-d85a19b8245e")
      dashku.set_api_url("http://localhost")      
      id = dashku.create_dashboard({:name => "waa"})["_id"]
      attrs = {
        :dashboardId  => id,
        :name         =>  "My little widgie",
        :html         =>  "<div id='bigNumber'></div>",
        :css          =>  "#bigNumber {\n  padding: 10px;\n  margin-top: 50px;\n  font-size: 36pt;\n  font-weight: bold;\n}",
        :script       =>  "// The widget's html as a jQuery object\nvar widget = this.widget;\n\n// This runs when the widget is loaded\nthis.on('load', function(data){\n  console.log('loaded');\n});\n// This runs when the widget receives a transmission\nthis.on('transmission', function(data){\n  widget.find('#bigNumber').text(data.bigNumber);\n});",
        :json         =>  "{\n  \"bigNumber\":500\n}"
      }
      req = dashku.create_widget(attrs)
      req.class.should     == Hash
      req["name"].should   == attrs[:name]
    end

    it "should throw and error if there is a problem" do
      dashku = Dashku.new
      dashku.set_api_key("c19cabb2-85d6-4be0-b1d6-d85a19b8245e")
      dashku.set_api_url("http://localhost")      
      attrs = {
        :dashboardId  =>  "rubbish",
        :name         =>  "My little widgie",
        :html         =>  "<div id='bigNumber'></div>",
        :css          =>  "#bigNumber {\n  padding: 10px;\n  margin-top: 50px;\n  font-size: 36pt;\n  font-weight: bold;\n}",
        :script       =>  "// The widget's html as a jQuery object\nvar widget = this.widget;\n\n// This runs when the widget is loaded\nthis.on('load', function(data){\n  console.log('loaded');\n});\n// This runs when the widget receives a transmission\nthis.on('transmission', function(data){\n  widget.find('#bigNumber').text(data.bigNumber);\n});",
        :json         =>  "{\n  \"bigNumber\":500\n}"
      }
      lambda {
        dashku.create_widget(attrs)
      }.should raise_error DashboardNotFoundError
    end

    it "should throw an error if the dashboard id is missing" do
      dashku = Dashku.new
      dashku.set_api_key("c19cabb2-85d6-4be0-b1d6-d85a19b8245e")
      dashku.set_api_url("http://localhost")      
      attrs = {
        :name         =>  "My little widgie",
        :html         =>  "<div id='bigNumber'></div>",
        :css          =>  "#bigNumber {\n  padding: 10px;\n  margin-top: 50px;\n  font-size: 36pt;\n  font-weight: bold;\n}",
        :script       =>  "// The widget's html as a jQuery object\nvar widget = this.widget;\n\n// This runs when the widget is loaded\nthis.on('load', function(data){\n  console.log('loaded');\n});\n// This runs when the widget receives a transmission\nthis.on('transmission', function(data){\n  widget.find('#bigNumber').text(data.bigNumber);\n});",
        :json         =>  "{\n  \"bigNumber\":500\n}"
      }
      lambda {
        dashku.create_widget(attrs)
      }.should raise_error MissingDashboardIdError
    end

  end

  describe "update_widget" do
    
    it "should return the widget object" do
      dashku = Dashku.new
      dashku.set_api_key("c19cabb2-85d6-4be0-b1d6-d85a19b8245e")
      dashku.set_api_url("http://localhost")      
      dashboard               = dashku.get_dashboards.select { |d| d["name"] == "waa" }
      dashboardId             = dashboard[0]["_id"]
      widget                  = dashboard[0]["widgets"][0]
      widget["name"]          = "King Widgie"
      widget["dashboardId"]   = dashboardId
      req                     = dashku.update_widget(widget)
      req.class.should        == Hash
      req["name"].should      == "King Widgie"
    end

    it "should throw an error if the dashboard id is missing" do
        dashku = Dashku.new
        dashku.set_api_key("c19cabb2-85d6-4be0-b1d6-d85a19b8245e")
        dashku.set_api_url("http://localhost")      
        dashboard   = dashku.get_dashboards.select { |d| d["name"] == "waa" }
        widget      = dashboard[0]["widgets"][0]
        lambda{
          dashku.update_widget(widget)
        }.should raise_error MissingDashboardIdError
    end

    it "should throw an error if the widget id is missing" do
        dashku = Dashku.new
        dashku.set_api_key("c19cabb2-85d6-4be0-b1d6-d85a19b8245e")
        dashku.set_api_url("http://localhost")      
        dashboard   = dashku.get_dashboards.select { |d| d["name"] == "waa" }
        dashboardId = dashboard[0]["_id"]
        widget      = dashboard[0]["widgets"][0]
        widget["dashboardId"] = dashboardId
        widget.delete("_id")
        lambda{
          dashku.update_widget(widget)
        }.should raise_error MissingIdError
    end

  end

end