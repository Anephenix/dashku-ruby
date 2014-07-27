require 'spec_helper.rb'
require 'dashku'
require 'json'

class MissingTestUserDataFileError < StandardError

  def message
    return "You need to create a testUser config file in /tmp/testUser.json. See README for details"
  end

end


# Raise an error if the testuser json file does not exist
#
testUserDataFilePath = "/tmp/testUser.json"

raise MissingTestUserDataFileError unless File.exist? testUserDataFilePath

data    = File.read testUserDataFilePath
config  = JSON.parse data 

test_api_key = config["apiKey"]
test_api_url = "http://localhost:3000"

describe Dashku do

  describe "set_api_key" do

    it "should set the api key for dashku" do      
      dashku = Dashku.new
      dashku.set_api_key "waaa"
      expect(dashku.api_key).to eq "waaa"
    end

  end

  describe "api_url" do
    
    it "should return the api url" do
      dashku = Dashku.new
      expect(dashku.api_url).to eq "https://dashku.com"
    end

  end

  describe "set_api_url" do

    it "should set the api url" do
      dashku = Dashku.new
      dashku.set_api_url "http://waaa"
      expect(dashku.api_url).to eq "http://waaa"
    end

  end

  describe "create_dashboard" do

    it "should return a dashboard object" do
      dashku = Dashku.new
      dashku.set_api_key test_api_key
      dashku.set_api_url test_api_url
      dashboard_attrs     = {name: "King Bishmael"}
      req                 = dashku.create_dashboard dashboard_attrs
      expect(req.class).to eq Hash
      expect(req["name"]).to eq dashboard_attrs[:name]
    end

    it "should throw an error if there is a problem" do
      dashku = Dashku.new
      dashku.set_api_key "waa"
      dashku.set_api_url test_api_url
      expect(lambda{ dashku.create_dashboard({}) }).to raise_error ApiKeyInvalidError
    end

  end

  describe "get_dashboards" do
    
    it "should return an array of dashboard objects" do
      dashku = Dashku.new
      dashku.set_api_key test_api_key
      dashku.set_api_url test_api_url
      expect(dashku.get_dashboards.class).to eq Array
    end

    it "should throw an error if there is a problem" do
      dashku = Dashku.new
      dashku.set_api_key "waa"
      dashku.set_api_url test_api_url
      expect(lambda{ dashku.get_dashboards }).to raise_error ApiKeyInvalidError
    end

  end

  describe "get_dashboard(id)" do
    
    it "should return a dashboard object" do
      dashku = Dashku.new
      dashku.set_api_key test_api_key
      dashku.set_api_url test_api_url
      id = dashku.get_dashboards[0]["_id"]
      expect(dashku.get_dashboard(id).class).to eq Hash
    end

    it "should throw an error if there is a problem" do
      dashku = Dashku.new
      dashku.set_api_key test_api_key
      dashku.set_api_url test_api_url
      expect(lambda{ dashku.get_dashboard("waa") }).to raise_error DashboardNotFoundError
    end

  end

  describe "update_dashboard" do

    it "should return a dashboard object" do
      dashku = Dashku.new
      dashku.set_api_key test_api_key
      dashku.set_api_url test_api_url
      dashboard = dashku.get_dashboards.select { |d| d["name"] == "King Bishmael" }
      dashboard = dashboard[0]
      dashboard["screenWidth"]    = "fluid"
      req                         = dashku.update_dashboard dashboard
      expect(req.class).to eq Hash
      expect(req["screenWidth"]).to eq dashboard["screenWidth"]
    end

    it "should throw an error if there is a problem" do
      dashku = Dashku.new
      dashku.set_api_key test_api_key
      dashku.set_api_url test_api_url
      expect(lambda {
        dashku.update_dashboard({"screenWidth" => "fluid"})
      }).to raise_error MissingIdError
    end

  end

  describe "create_widget" do

    it "should return the widget object" do
      dashku = Dashku.new
      dashku.set_api_key test_api_key
      dashku.set_api_url test_api_url
      id = dashku.create_dashboard({:name => "waa"})["_id"]
      attrs = {
        :dashboardId  => id,
        :name         =>  "My little widgie",
        :html         =>  "<div id='bigNumber'></div>",
        :css          =>  "#bigNumber {\n  padding: 10px;\n  margin-top: 50px;\n  font-size: 36pt;\n  font-weight: bold;\n}",
        :script       =>  "// The widget's html as a jQuery object\nvar widget = this.widget;\n\n// This runs when the widget is loaded\nthis.on('load', function(data){\n  console.log('loaded');\n});\n// This runs when the widget receives a transmission\nthis.on('transmission', function(data){\n  widget.find('#bigNumber').text(data.bigNumber);\n});",
        :json         =>  "{\n  \"bigNumber\":500\n}"
      }
      req = dashku.create_widget attrs
      expect(req.class).to eq Hash
      expect(req["name"]).to eq attrs[:name]
    end

    it "should throw and error if there is a problem" do
      dashku = Dashku.new
      dashku.set_api_key test_api_key
      dashku.set_api_url test_api_url
      attrs = {
        :dashboardId  =>  "rubbish",
        :name         =>  "My little widgie",
        :html         =>  "<div id='bigNumber'></div>",
        :css          =>  "#bigNumber {\n  padding: 10px;\n  margin-top: 50px;\n  font-size: 36pt;\n  font-weight: bold;\n}",
        :script       =>  "// The widget's html as a jQuery object\nvar widget = this.widget;\n\n// This runs when the widget is loaded\nthis.on('load', function(data){\n  console.log('loaded');\n});\n// This runs when the widget receives a transmission\nthis.on('transmission', function(data){\n  widget.find('#bigNumber').text(data.bigNumber);\n});",
        :json         =>  "{\n  \"bigNumber\":500\n}"
      }
      expect(lambda {
        dashku.create_widget attrs
      }).to raise_error DashboardNotFoundError
    end

    it "should throw an error if the dashboard id is missing" do
      dashku = Dashku.new
      dashku.set_api_key test_api_key
      dashku.set_api_url test_api_url
      attrs = {
        :name         =>  "My little widgie",
        :html         =>  "<div id='bigNumber'></div>",
        :css          =>  "#bigNumber {\n  padding: 10px;\n  margin-top: 50px;\n  font-size: 36pt;\n  font-weight: bold;\n}",
        :script       =>  "// The widget's html as a jQuery object\nvar widget = this.widget;\n\n// This runs when the widget is loaded\nthis.on('load', function(data){\n  console.log('loaded');\n});\n// This runs when the widget receives a transmission\nthis.on('transmission', function(data){\n  widget.find('#bigNumber').text(data.bigNumber);\n});",
        :json         =>  "{\n  \"bigNumber\":500\n}"
      }
      expect(lambda {
        dashku.create_widget attrs
      }).to raise_error MissingDashboardIdError
    end

  end

  describe "update_widget" do
    
    it "should return the widget object" do
      dashku = Dashku.new
      dashku.set_api_key test_api_key
      dashku.set_api_url test_api_url
      dashboard               = dashku.get_dashboards.select { |d| d["name"] == "waa" }
      dashboardId             = dashboard[0]["_id"]
      widget                  = dashboard[0]["widgets"][0]
      widget["name"]          = "King Widgie"
      widget["dashboardId"]   = dashboardId
      req                     = dashku.update_widget widget
      expect(req.class).to    eq Hash
      expect(req["name"]).to  eq "King Widgie"
    end

    it "should throw an error if the dashboard id is missing" do
        dashku = Dashku.new
        dashku.set_api_key test_api_key
        dashku.set_api_url test_api_url
        dashboard   = dashku.get_dashboards.select { |d| d["name"] == "waa" }
        widget      = dashboard[0]["widgets"][0]
        expect(lambda{
          dashku.update_widget(widget)
        }).to raise_error MissingDashboardIdError
    end

    it "should throw an error if the widget id is missing" do
        dashku = Dashku.new
        dashku.set_api_key test_api_key
        dashku.set_api_url test_api_url
        dashboard   = dashku.get_dashboards.select { |d| d["name"] == "waa" }
        dashboardId = dashboard[0]["_id"]
        widget      = dashboard[0]["widgets"][0]
        widget["dashboardId"] = dashboardId
        widget.delete("_id")
        expect(lambda{
          dashku.update_widget widget
        }).to raise_error MissingIdError
    end

  end

  describe "delete_widget" do

    it "should return the id of the deleted widget" do
      dashku = Dashku.new
      dashku.set_api_key test_api_key
      dashku.set_api_url test_api_url
      dashboard               = dashku.get_dashboards.select { |d| d["name"] == "waa" }
      dashboardId             = dashboard[0]["_id"]
      widgetId                = dashboard[0]["widgets"][0]["_id"]
      req                     = dashku.delete_widget dashboardId, widgetId
      expect(req["widgetId"]).to eq widgetId
    end

    it "should throw an error if the dashboard is not found" do
      dashku = Dashku.new
      dashku.set_api_key test_api_key
      dashku.set_api_url test_api_url
      expect(lambda {
        dashku.delete_widget "rubbish","waa"
      }).to raise_error DashboardNotFoundError
    end

    it "should throw an error if the widget is not found" do
      dashku = Dashku.new
      dashku.set_api_key test_api_key
      dashku.set_api_url test_api_url
      dashboard   = dashku.get_dashboards.select { |d| d["name"] == "waa" }
      dashboardId = dashboard[0]["_id"]
      expect(lambda {
        dashku.delete_widget dashboardId, "waa"
      }).to raise_error WidgetNotFoundError

    end

  end

  describe "transmission" do
    
    it "should return a success status" do
      dashku = Dashku.new
      dashku.set_api_key test_api_key
      dashku.set_api_url test_api_url
      dashboard   = dashku.get_dashboards.select { |d| d["name"] == "waa" }
      dashboardId = dashboard[0]["_id"]
      attrs = {
        :dashboardId  =>  dashboardId,
        :name         =>  "My little widgie",
        :html         =>  "<div id='bigNumber'></div>",
        :css          =>  "#bigNumber {\n  padding: 10px;\n  margin-top: 50px;\n  font-size: 36pt;\n  font-weight: bold;\n}",
        :script       =>  "// The widget's html as a jQuery object\nvar widget = this.widget;\n\n// This runs when the widget is loaded\nthis.on('load', function(data){\n  console.log('loaded');\n});\n// This runs when the widget receives a transmission\nthis.on('transmission', function(data){\n  widget.find('#bigNumber').text(data.bigNumber);\n});",
        :json         =>  "{\n  \"bigNumber\":500\n}"
      }
      req = dashku.create_widget attrs
      data = req["json"]

      req = dashku.transmission data
      expect(req.class).to eq Hash
      expect(req["status"]).to eq "success"      
    end

  end

  describe "delete_dashboard" do

    it "should return the id of the deleted dashboard" do
      dashku = Dashku.new
      dashku.set_api_key test_api_key
      dashku.set_api_url test_api_url
      dashboard = dashku.get_dashboards.select { |d| d["name"] == "King Bishmael" }
      dashboard = dashboard[0]
      expect(dashku.delete_dashboard(dashboard["_id"])["dashboardId"]).to eq dashboard["_id"]            
    end

    it "should throw an error if there is a problem" do
      dashku = Dashku.new
      dashku.set_api_key test_api_key
      dashku.set_api_url test_api_url
      expect(lambda {
        dashku.delete_dashboard "waa"
      }).to raise_error DashboardNotFoundError
    end

  end

end