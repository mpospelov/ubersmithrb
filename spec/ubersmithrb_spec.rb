
require 'spec_helper'
require 'json'
require 'yaml'

describe Ubersmith do
  before(:all) do
    config = YAML.load(File.open('spec/config.yml'))
    @url = config["test"]["url"]
    @user = config["test"]["user"]
    @token = config["test"]["token"]
    @api = Ubersmith::API.new(@url, @user, @token)
    @cid = 0
  end

  it 'should return a successful response' do
    o = @api.uber.method_get({:method_name => "uber.metadata_get"})
    o.ok?.should eq (true)
    o['params'].should_not eq (nil)
  end

  it 'should add and deactivate client' do
    client = @api.client.add({:first_name => "Test", :last_name => "User", :email => "mkennedy@object-brewery.com"})
    client.ok?.should eq (true)
    client.error?.should eq (false)
    client.data.to_i.should_not eq (0)
    res = @api.client.deactivate({:client_id => client.data})
    res.ok?.should eq (true)
    res.data.should eq (true)
  end

  it 'should return client list' do
    list = @api.client.list({:short => 1, :active => 1})
    list.empty?.should eq (false)
    list.count.should > 1
  end

  it 'should get a device list' do
    list = @api.device.list
    list.ok?.should eq (true)
  end

  it 'should get a support count' do
    result = @api.support.ticket_count
    result.ok?.should eq (true)
  end

  it 'should get an error for non-existant API' do
    result = @api.order.made_up_function_not_real
    result.ok?.should eq (false)
    result = @api.sales.another_fake_function
    result.ok?.should eq (false)
  end

  it 'should get an error for a bad URL' do
    bapi = Ubersmith::API.new('http://127.0.0.1/foo/bar/', @user, @token)
    result = bapi.device.list
    result.error_code.should eq (500)
    result.error_message.should_not eq (nil)
    result.ok?.should eq (false)
    result.message.should_not eq (nil)
  end
end
