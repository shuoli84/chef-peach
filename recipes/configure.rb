#
# Cookbook Name:: chef-peach
# Recipe:: configure
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Get peach server value from node
# Generate /etc/peach/conf.json

require 'json'

file "/etc/peach/conf.json" do
  if node.attribute?(:peach) && node[:peach].attribute?(:server)
    peach_server = node.peach.server
    if peach_server
      content({:server=>peach_server}.to_json)
      mode '0644'
      action :create
    else
      action :delete
    end
  else
    action :delete
  end
end
