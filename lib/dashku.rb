class Dashku

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
    @api_url = api_url
  end

end