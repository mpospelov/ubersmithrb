
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
    expect(o.ok?).to eq(true)
    expect(o['params']).to_not eq(nil)
  end

  it 'should add and deactivate client' do
    client = @api.client.add({:first_name => "Test", :last_name => "User", :email => "mkennedy@object-brewery.com"})
    expect(client.ok?).to eq(true)
    expect(client.error?).to eq(false)
    expect(client.data.to_i).to_not eq(0)
    res = @api.client.deactivate({:client_id => client.data})
    expect(res.ok?).to eq(true)
    expect(res.data).to eq(true)
  end

  it 'should return client list' do
    list = @api.client.list({:short => 1, :active => 1})
    expect(list.empty?).to eq(false)
    expect(list.count > 1).to eq(true)
  end

  it 'should get a device list' do
    list = @api.device.list
    expect(list.ok?).to eq(true)
  end

  it 'should get a support count' do
    result = @api.support.ticket_count
    expect(result.ok?).to eq(true)
  end

  it 'should get an error for non-existant API' do
    result = @api.order.made_up_function_not_real
    expect(result.ok?).to eq(false)
    result = @api.sales.another_fake_function
    expect(result.ok?).to eq(false)
  end

  it 'should get an error for a bad URL' do
    bapi = Ubersmith::API.new('http://127.0.0.1/foo/bar/', @user, @token)
    result = bapi.device.list
    expect(result.error_code).to eq(500)
    expect(result.error_message).to_not eq(nil)
    expect(result.ok?).to eq(false)
    expect(result.message).to_not eq(nil)
  end
end
