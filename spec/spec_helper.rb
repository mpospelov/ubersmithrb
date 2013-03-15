
require 'simplecov'
SimpleCov.start

require 'rspec'
require 'ubersmithrb'

RSpec.configure do |config|
  config.color_enabled  = true
  config.formatter      = 'documentation'
  unless File.exists?('spec/config.yml')
    puts "Missing config.yml"
    puts "File out the values in spec/config.yml in the spec directory with your Ubersmith API settings before proceeding."
    File.open("spec/config.yml", "w") do |f|
      f.write <<HERE
test:
  url: http://your.ubersmith.com/api/2.0/
  user: YOUR USER NAME
  token: YOUR API TOKEN
HERE
      f.close
    end
    exit
  end
end

