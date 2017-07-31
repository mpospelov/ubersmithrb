require 'mechanize'
require 'json'
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
      @agent = Mechanize.new
      @agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    # Returns a formatted API command call URL.
    def command_url(cmd)
      "#{@url}?method=#{@modname.to_s}.#{cmd}"
    end

    # This class uses method_missing for handling delegation to the API method.
    # When making a call from this class call the method as you would a normal
    # ruby method. Parameters passed should be a hash of all the fields to
    # send to the API. Consult the ubersmith API docs for the necessary fields
    # for each API call.
    def method_missing(sym, *args)
      cmd = command_url(sym)
      @agent.add_auth(cmd, @user, @token)
      resp = nil
      begin
        a = args.first
#        puts "#{cmd}(#{a.inspect})"
        page = (a.nil?) ? @agent.get(cmd) : @agent.post(cmd, a)
#        puts "#{page.content}"
        resp = Ubersmith::Response.new(JSON.parse(page.content))
      rescue Exception => e
        if !page.nil? and !page.content.nil? and page.content.include?("PDF")
          resp = Ubersmith::Response.new({'status' => true, 'data' => page.content})
        elsif !page.nil? and !page.content.nil? and page.content.include?("HTML")
          resp = Ubersmith::Response.new({'status' => true, 'data' => page.content})
        else
          resp = Ubersmith::Response.new({'status' => false, 'error_code' => 500, 'error_message' => e.message})
        end
      end
      resp
    end
  end
end
