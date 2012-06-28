require 'httparty'

class Dashku
  include HTTParty

  def initialize
    @api_url = "http://176.58.100.203"
  end

  def api_key
    @api_key
  end

  def api_url
    @api_url
  end

  def set_api_key(api_key)
    @api_key = api_key
  end

  def set_api_url(api_url)
    self.class.base_uri api_url
    @api_url = api_url
  end

  def get_dashboards
    request = self.class.get "/api/dashboards", :query => {:apiKey => @api_key}
    if request.response.class == Net::HTTPOK
      return request.parsed_response
    elsif request.response.class == Net::HTTPUnauthorized
      raise ApiKeyInvalidError
    end
  end

  def get_dashboard(id)
    request = self.class.get "/api/dashboards/#{id}", :query => {:apiKey => @api_key}
    if request.response.class == Net::HTTPOK
      return request.parsed_response
    elsif request.response.class == Net::HTTPBadRequest
      raise DashboardNotFoundError
    elsif request.response.class == Net::HTTPUnauthorized
      raise ApiKeyInvalidError
    end
  end

end

class ApiKeyInvalidError < StandardError

  def message
    "Couldn't find a user with that API key"
  end

end

class DashboardNotFoundError < StandardError

  def message
    "Dashboard not found"
  end

end