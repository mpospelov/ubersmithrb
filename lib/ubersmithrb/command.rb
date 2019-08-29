require 'net/http'
require 'oj'
require 'ubersmithrb/response'

module Ubersmith
  # This class is the command handler for sending API commands and processing the
  # response. Each instance of the handler is given a module name and method calls
  # made to instances of this class will then be delegated to that API module.
  class Command
    def initialize(modname, url, user, token)
      @modname = modname
      @url = url
      @user = user
      @token = token
    end

    # Returns a formatted API command call URL.
    def command_uri(cmd)
      URI("#{@url}?method=#{@modname.to_s}.#{cmd}")
    end

    def run_method(method_name, req_body = nil)
      cmd = command_uri(method_name)
      response = fetch(cmd, req_body)
      if response.code_type == Net::HTTPOK
        if is_json?(response)
          Ubersmith::Response.new(Oj.load(response.body))
        else
          Ubersmith::Response.new('status' => true, 'data' => response.body)
        end
      else
        Ubersmith::Response.new('status' => false, 'error_code' => 500, 'error_message' => response.body)
      end
    rescue SystemCallError, Net::HTTPClientError => e
      Ubersmith::Response.new('status' => false, 'error_code' => 500, 'error_message' => e.message)
    end

    # This class uses method_missing for handling delegation to the API method.
    # When making a call from this class call the method as you would a normal
    # ruby method. Parameters passed should be a hash of all the fields to
    # send to the API. Consult the ubersmith API docs for the necessary fields
    # for each API call.
    def method_missing(sym, *args)
      self.class.define_method(sym) { |req_body = nil| run_method(sym, req_body) }
      public_send(sym, *args)
    end

    private

    def is_json?(response)
      response['Content-Type'] == 'application/json'
    end

    def fetch(cmd, req_body)
      request = if req_body.nil?
        Net::HTTP::Get.new(cmd)
      else
        Net::HTTP::Post.new(cmd).tap { |r| r.set_form_data(req_body) }
      end
      request.basic_auth(@user, @token)
      Net::HTTP.start(cmd.hostname, cmd.port) do |http|
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.request(request)
      end
    end
  end
end
