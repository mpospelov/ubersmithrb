
module Ubersmith

  # This class represents a response from the API. It maintains the result status
  # and any error codes and messages in addition to the data portion of the API response.
  class Response
    def initialize(raw = {'status' => false, 'error_code' => '999', 'error_message' => 'No response'})
      @response = raw
    end

    # Returns true if the API call was successful.
    def ok?
      @response['status'] == true
    end

    # Returns true if the API had an error.
    def error?
      @response['status'] != true
    end

    # Return an message string. OK if successful, or error code and message if error.
    def message
      (ok?) ? "OK" : "(#{error_code}): #{error_message}"
    end

    # Returns the error code if one was given.
    def error_code
      @response['error_code']
    end
  
    # Returns the error message if one was given.
    def error_message
      @response['error_message']
    end

    # Returns parsed data result from the API call. For many API calls this will
    # be a nested hash data structure. For some it may be a scalar value. Consult
    # the Ubersmith API docs for the value to expect for each call.
    def data
      @response['data']
    end

    # This class provides a convenience means via method_missing to delegate to the 
    # data results of the response so that the main object can be treated like the
    # data directly.
    def method_missing(sym, *args)
      if args.empty?
        @response['data'].send(sym)
      else
        @response['data'].send(sym, *args)
      end
    end

  end
end
