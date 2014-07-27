Dashku Rubygem
===========

A wrapper to the [Dashku.com](https://dashku.com) API. Also used with Dashku open source edition.

[![Gem Version](https://badge.fury.io/rb/dashku.png)](http://badge.fury.io/rb/dashku)
[![Dependency Status](https://gemnasium.com/Anephenix/dashku-ruby.svg)](https://gemnasium.com/Anephenix/dashku-ruby)
[![Coverage Status](https://img.shields.io/coveralls/Anephenix/dashku-ruby.png)](https://coveralls.io/r/Anephenix/dashku-ruby)
[![Build Status](https://travis-ci.org/Anephenix/dashku-ruby.png?branch=master)](https://travis-ci.org/Anephenix/dashku-ruby)
[![Code Climate](https://codeclimate.com/github/Anephenix/dashku-ruby.png)](https://codeclimate.com/github/Anephenix/dashku-ruby)


Install
---

    gem install dashku

Example Usage
---

Require the library, and set your api key

```ruby
    require 'dashku'

    dashku = Dashku.new
    dashku.set_api_key("YOUR_API_KEY")

    # Fetches your dashboards
    dashku.get_dashboards
```

NOTE - If you are using Dashku Open Source Edition, you will need to run this command with the Rubygem:

```ruby
    dashku.set_api_url("YOUR_API_URL")
```

Available Commands
---

* set_api_key
* set_api_url
* get_dashboards
* get_dashboard
* create_dashboard
* update_dashboard
* delete_dashboard
* create_widget
* update_widget
* delete_widget
* transmission

set_api_key
---

Allows you to provide your api key to the library. This needs to be called before any API request can be made. To get your API key, checkout the API docs in Dashku.

```ruby
    # Set the api key, then run your code
    dashku.set_api_key("YOUR_API_KEY")
```

set_api_url
---

Allows you to define the api url to the library. This may come is useful if the API url changes, as it is currently pointing to Dashku.com's ip address.

```ruby
    # Set the api url, then run your code
    dashku.set_api_url("API_URL")
```

get_dashboards
---

Retrieves all of your dashboards.

```ruby
    # This will return an array of Dashboards
    dashku.get_dashboards

    # If there is an error, an exception will be raised. See 'exceptions' in this README for more.
```

get_dashboard
---

Retrieves a dashboard, given the id of the dashboard.

```ruby
    # This will return a Dashboard object
    dashku.get_dashboard("DASHBOARD_ID")

    # If there is an error, an exception will be raised. See 'exceptions' in this README for more.
```

create_dashboard
---

Creates a dashboard, given some attributes.

```ruby
    attributes = {:name => "My new dashboard"}
    # This will return a Dashboard object
    dashku.create_dashboard(attributes)

    # If there is an error, an exception will be raised. See 'exceptions' in this README for more.
```

update_dashboard
---

Updates a dashboard, given some attributes.

```ruby
    attributes = {:_id => "DASHBOARD_ID", :screenWidth => "fluid"}
    # This will return a Dashboard object
    dashku.update_dashboard(attributes)

    # If there is an error, an exception will be raised. See 'exceptions' in this README for more.
```

delete_dashboard
---

Deletes a dashboard, given the id of the dashboard.

```ruby
    # This will return the deletes dashboard's id
    dashku.delete_dashboard("DASHBOARD_ID")

    # If there is an error, an exception will be raised. See 'exceptions' in this README for more.
```

create_widget
---

Creates a widget, given some attributes.

```ruby
    attributes = {
      :dashboardId  => "DASHBOARD_ID",
      :name         => "My little widget",
      :html         => "<div id='bigNumber'></div>",
      :css          => "#bigNumber {\n  padding: 10px;\n  margin-top: 50px;\n  font-size: 36pt;\n  font-weight: bold;\n}",
      :script       => "// The widget's html as a jQuery object\nvar widget = this.widget;\n\n// This runs when the widget is loaded\nthis.on('load', function(data){\n  console.log('loaded');\n});\n// This runs when the widget receives a transmission\nthis.on('transmission', function(data){\n  widget.find('#bigNumber').text(data.bigNumber);\n});",
      :json         => "{\n  \"bigNumber\":500\n}"
    }

    # This will return a Widget object
    dashku.create_widget(attributes)

    # If there is an error, an exception will be raised. See 'exceptions' in this README for more.
```

update_widget
---

Updates an existing widget, given some attributes.

```ruby
    attributes = {
      :dashboardId  => "DASHBOARD_ID",
      :_id          => "WIDGET_ID",  
      :name         => "King widget"
    }

    # This will return a Widget object
    dashku.update_widget(attributes)    

    # If there is an error, an exception will be raised. See 'exceptions' in this README for more.
```

delete_widget
---

Deletes an existing widget, given a dashboard id and widget id

```ruby
    # This returns the ID of the deleted widget
    dashku.delete_widget('DASHBOARD_ID','WIDGET_ID')

    # If there is an error, an exception will be raised. See 'exceptions' in this README for more.
```

transmission
---

Transmits data to an existing widget, given an object that can be converted to JSON

```ruby
    data = {
      :_id        => "WIDGET_ID",
      :bigNumber  => 500
    }

    # This returns a simple hash with the status "success"
    dashku.transmission(data)

    # If there is an error, an exception will be raised. See 'exceptions' in this README for more.
```

Exceptions
---

If a request fails for a reason, an exception is thrown, and you'll want to rescue that exception in your code. These are the exceptions to handle:

* ApiKeyInvalidError

  This exception is raised if the API Key provided is incorrect

* DashboardNotFoundError

  This exception is raised if the dashboard is not found. This can happen if the supplied dashboard id is incorrect, or if the dashboard was deleted.

* WidgetNotFoundError

  This exception is raised if the widget is not found. This can happen if the supplied widget id is incorrect, or if the widget was deleted.

* MissingIdError

  This exception is raised if the "_id" attribute passed to the 'update_dashboard' or 'update_widget' API calls is missing.

* MissingDashboardIdError

  This exception is raised if the "dashboardId" attribute passed to the 'create_widget' or 'update_widget' API calls is missing. 

Copyright
---

&copy; 2014 Anephenix Ltd. Dashku is licensed under the MIT License.
