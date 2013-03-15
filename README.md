# Ubersmithrb

This is a gem to provide integration to an Ubersmith server via the Ubersmith API.

## Installation

Add this line to your application's Gemfile:

    gem 'ubersmithrb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ubersmithrb

## Usage

Using this module requires being familiar with the Ubersmith API. Documentation for it 
can be found at http://www.ubersmith.com/kbase/index.php?_m=downloads&_a=view&parentcategoryid=2.

Example showing how to list active client IDs in the system:

```ruby
require 'ubersmithrb'
api = Ubersmith::API.new("http://your.ubersmithurl.com/api/2.0/", "username", "token")
result = api.client.list
unless result.error?
  result.keys.each {|k| puts k}
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
