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

### Example Order Queue Workflow

Ubersmith has a very flexible and configurable workflow for managing order processing. This
example shows the basics of putting a full order through a queue.

```ruby
require 'ubersmithrb'

api = Ubersmith::API.new("http://testserver.com/api/2.0/", "apiuser", "token")

# Create a client for the order. Clients can be created as part of the order process, but this 
# example will show the creation of an client and an order for that client.
client = api.client.add({:first_name => "John", :last_name => "Doe", :email => "jdoe@test.com"})
raise "Failed to create client." unless client.ok?

puts "Client created. ID #{client.data}"

# Placing payment info on the order does not automatically add it to the client too. In order 
# to have payment info on file for the recurring payments you will need to add it to the client.
#
# NOTE: Expiration Date for CCs is expected in MMYY format with no slash or dash in between 
# the MM and YY
ccinfo = api.client.cc_add({
  :client_id => client.data,
  :cc_num => '5105105105105100',
  :cc_expire => '0115',
  :cc_cvv2 => '123',
  :cc_first => 'John',
  :cc_last => 'Doe',
  :cc_zip => '12345'
})
rails "Failed to add cc to client" unless ccinfo.ok?
puts "CC Added to client record"

# Create an order for the client. The values for :order_form_id, :order_queue_id, and the 
# plan_id are subject to change. These are example values which will need changed to match 
# your ubersmith environment. The key names for the info data are because the ubersmith API
# is PHP based and accepts the parameters as POST data, not proper JSON. It assumes POST 
# formatting of a PHP hash the way PHP does it, so we have to format our parameters appropriately.
order = api.order.create({
  :order_form_id => 1,
  :order_queue_id => 1,
  :client_id => client.data,
  "info[pack1][plan_id]" => 1,
  'info[payment_type]' => 'cc',
  'info[cc_num]' => '5105105105105100',
  'info[cc_expire]' => '0115',
  'info[cc_cvv2]' => '123',
  'info[cc_first]' => 'John',
  'info[cc_last]' => 'Doe',
  'info[cc_zip]' => '17563',
  'info[AUPTOS]' => 1
})
raise "Failed to create order" unless order.ok?
puts "Added order. ID #{order['order_id']}"

# Now that the order is created it is in a 'Lead' state. To get the work flow moving we
# now have to process it.
process = api.order.submit({:order_id => order['order_id']})
raise "Failed to update order" unless process.ok?
puts "Order submitted"

# Now the order is in the processing phase. There are several steps which can happen here.
# For the final order workflow some or all of them may be handled automatically. For this
# example we're going to tell the order queue to skip the first step. :order_action_id of 1
# is Provision Client for this queue's workflow. We've already created that so we're going
# to skip it by sending :skip => 1.
#
# Note that :order_action_id values will be dependent upon the specific order queues in your 
# ubersmith environment.
process = api.order.process({:order_id => order['order_id'], :order_action_id => 1, :skip => 1})
raise "Failed to process order" unless process.ok?
puts "Order processed"

# At this point the our test workflow will perform all of the remaining steps automatically,
# so you're done. To demonstrate actually working through the steps here are some examples.
# Same type of call, just without the :skip. In the example workflow :order_action_id of 2 is
# 'Add Services' and :order_action_id of 3 is 'Generate Invoice'. They may be configured to
# happen automatically when the 'Provision Client' step is done or skipped.
#
#   process = api.order.process({:order_id => order['order_id'], :order_action_id => 2})
#   process = api.order.process({:order_id => order['order_id'], :order_action_id => 3})
#
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
