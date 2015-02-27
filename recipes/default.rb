#
# Cookbook Name:: chef-peach
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
chef_gem "json"

remote_file '/tmp/baidu_test' do
  source 'http://www.baidu.com'
end

