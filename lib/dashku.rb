require 'httparty'

class Dashku
  include HTTParty

  def initialize
    @api_url = "https://dashku.com"
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
 
  def create_dashboard(attrs)
    request = self.class.post "/api/dashboards", :query => {:apiKey => @api_key}, :body => attrs
    if request.response.class == Net::HTTPAccepted
      return request.parsed_response
    elsif request.response.class == Net::HTTPUnauthorized
      raise ApiKeyInvalidError
    end
  end

  def update_dashboard(attrs)
    id = attrs["_id"] || attrs[:_id]
    raise MissingIdError if id.nil?
    request = self.class.put "/api/dashboards/#{id}", :query => {:apiKey => @api_key}, :body => attrs    
    if request.response.class == Net::HTTPCreated
      return request.parsed_response
    elsif request.response.class == Net::HTTPUnauthorized
      raise ApiKeyInvalidError
    end
  end

  def delete_dashboard(id)
    request = self.class.delete "/api/dashboards/#{id}", :query => {:apiKey => @api_key}    
    if request.response.class == Net::HTTPCreated
      return request.parsed_response
    elsif request.response.class == Net::HTTPBadRequest
      raise DashboardNotFoundError
    elsif request.response.class == Net::HTTPUnauthorized
      raise ApiKeyInvalidError
    end
  end

  def create_widget(attrs)
    dashboardId = attrs["dashboardId"] || attrs[:dashboardId]
    raise MissingDashboardIdError if dashboardId.nil?
    request = self.class.post "/api/dashboards/#{dashboardId}/widgets", :query => {:apiKey => @api_key}, :body => attrs
    if request.response.class == Net::HTTPAccepted
      return request.parsed_response
    elsif request.response.class == Net::HTTPBadRequest
      raise DashboardNotFoundError
    elsif request.response.class == Net::HTTPUnauthorized
      raise ApiKeyInvalidError
    end    
  end

  def update_widget(attrs)
    dashboardId = attrs["dashboardId"] || attrs[:dashboardId]
    raise MissingDashboardIdError if dashboardId.nil?
    id = attrs["_id"] || attrs[:_id]
    raise MissingIdError if id.nil?
    request = self.class.put "/api/dashboards/#{dashboardId}/widgets/#{id}", :query => {:apiKey => @api_key}, :body => attrs
    if request.response.class == Net::HTTPCreated
      return request.parsed_response
    elsif request.response.class == Net::HTTPBadRequest
      raise DashboardNotFoundError
    elsif request.response.class == Net::HTTPUnauthorized
      raise ApiKeyInvalidError
    end
  end

  def delete_widget(dashboardId, id)
    request = self.class.delete "/api/dashboards/#{dashboardId}/widgets/#{id}", :query => {:apiKey => @api_key}
    if request.response.class == Net::HTTPCreated
      return request.parsed_response
    elsif request.response.class == Net::HTTPBadRequest
      if request.parsed_response["reason"].match("No dashboard found")
        raise DashboardNotFoundError
      else
        raise WidgetNotFoundError
      end
    elsif request.response.class == Net::HTTPUnauthorized
      raise ApiKeyInvalidError
    end    
  end

  def transmission(data)
    request = self.class.post "/api/transmission", :query => {:apiKey => @api_key}, :body => data   
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

class WidgetNotFoundError < StandardError
  def message
    "Widget not found"
  end
end

class MissingIdError < StandardError
  def message
    "Your attributes are missing an _id field"
  end
end

class MissingDashboardIdError < StandardError
  def message
    "Your attributes are missing a dashboardId field"
  end
end