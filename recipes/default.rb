#
# Cookbook Name:: hipsnip-elasticsearch
# Recipe:: default
#
# Copyright 2013, HipSnip Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "java" # @TODO - make this optional in the future
include_recipe "ark::default"

Erubis::Context.send(:include, Extensions::Templates)


################################################################################
# Set up Elasticsearch user, group and folders

group node['elasticsearch']['group'] do
  gid node['elasticsearch']['group_id']
  action :create
end

user node['elasticsearch']['user'] do
  gid   node['elasticsearch']['group_id']
  shell '/bin/false' # no login
  # no home dir
end

directory node['elasticsearch']['path']['conf'] do
  mode  '755'
  owner 'root'
  group 'root'
end

directory node['elasticsearch']['path']['logs'] do
  mode  '755'
  owner node['elasticsearch']['user']
  group node['elasticsearch']['group']
end

directory node['elasticsearch']['path']['data'] do
  mode  '755'
  owner node['elasticsearch']['user']
  group node['elasticsearch']['group']
end


################################################################################
# Download and install binaries

node.set['elasticsearch']['download']['url'] = "http://#{node['elasticsearch']['download']['host']}/#{node['elasticsearch']['download']['subfolder']}/elasticsearch-#{node['elasticsearch']['download']['version']}.tar.gz"

ark "elasticsearch" do
  url node['elasticsearch']['download']['url']
  owner node['elasticsearch']['user']
  group node['elasticsearch']['group']
  version node['elasticsearch']['download']['version']
  has_binaries ['bin/elasticsearch', 'bin/plugin']
  checksum node['elasticsearch']['download']['checksum']
  prefix_root   node['elasticsearch']['path']['install']
  prefix_home   node['elasticsearch']['path']['install']

  # @TODO - Investigate why we need this here! Ark should only download things once...
  not_if do
    binary = "#{node['elasticsearch']['path']['install']}/bin/elasticsearch"
    target = "#{node['elasticsearch']['path']['install']}/elasticsearch-#{node['elasticsearch']['download']['version']}/bin/elasticsearch"
    ::File.exists?(binary) && ::File.readlink(binary) == target
  end
end


################################################################################
# Install any defined Plugins

directory "#{node['elasticsearch']['path']['install']}/elasticsearch-#{node['elasticsearch']['download']['version']}/plugins" do
  owner node['elasticsearch']['user']
  group node['elasticsearch']['group']
  mode '755'
  recursive true
end

