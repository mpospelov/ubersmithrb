require "ubersmithrb/version"
require "ubersmithrb/response"
require "ubersmithrb/command"

# This gem provides programmatic access to the Ubersmith API from ruby. To use it create
# an instance of the Ubersmith::API class using the url, username, and api token for 
# the Ubersmith server. 
#
#   require 'ubersmithrb'
#   api = Ubersmith::API.new(myurl, myuser, mytoken)
#   result = api.client.create({:first_name => "Test", :last_name => "User"})
#   puts result.message
module Ubersmith

  # This class serves as the API handle for communicating with an ubersmith server.
  # It contains accessors for communicating with each of the ubersmith API 
  # modules. When instantiated it requires the API URL to connect to and the user
  # name and API token to use. For documentation of the Ubersmith API calls 
  # available see http://www.ubersmith.com/kbase/index.php?_m=downloads&_a=view&parentcategoryid=2
  class API

    # Initializer method. Accepts API URL, username, and API token as parameters.
    def initialize(url, user, token)
      @url = url
      @user = user
      @token = token
      @modules = {}
      [:uber, :client, :device, :order, :sales, :support].each do |mod|
        @modules[mod] = Ubersmith::Command.new(mod, url, user, token)
      end
    end

    # This accessor is used for calling API methods under the uber module.
    def uber
      @modules[:uber]
    end

    # This accessor is used for calling API methods under the client module.
    def client
      @modules[:client]
    end

    # This accessor is used for calling API methods under the device module.
    def device
      @modules[:device]
    end
    
    # This accessor is used for calling API methods under the order module.
    def order
      @modules[:order]
    end

    # This accessor is used for calling API methods under the sales module.
    def sales
      @modules[:sales]
    end

    # This accessor is used for calling API methods under the support module.
    def support
      @modules[:support]
    end
  end
end
