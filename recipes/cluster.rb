#
# Cookbook Name:: hipsnip-elasticsearch
# Recipe:: cluster
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

require 'set'

if Chef::Config[:solo]
  raise "Sorry - this recipe is for Chef Server only"
end

include_recipe "hipsnip-elasticsearch::default"

node.set['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = false

################################################################################
# Find all nodes for cluster

node.default['elasticsearch']['discovery']['search_query'] = "chef_environment:#{node.chef_environment} AND elasticsearch_cluster_name:#{node['elasticsearch']['cluster']['name']}"
node_results = search("node", node['elasticsearch']['discovery']['search_query']) || []
Chef::Log.debug("Found #{node_results.length} Elasticsearch cluster node(s)")


################################################################################
# Gather node info

cluster_nodes = Set.new

node_results.each do |n|
  host = node['elasticsearch']['discovery']['node_attribute'].split('.').inject(n){|val,a| val[a]} || n['fqdn']
  port = n['elasticsearch']['transport']['tcp']['port']
  cluster_nodes << "#{host}:#{port}"
end

this_node_host = node['elasticsearch']['discovery']['node_attribute'].split('.').inject(node){|val,a| val[a]} || node['fqdn']
this_node_port = node['elasticsearch']['transport']['tcp']['port']
this_node = "#{this_node_host}:#{this_node_port}"
cluster_nodes << this_node


################################################################################
# Update cluster config

node.set['elasticsearch']['discovery']['zen']['ping']['unicast']['hosts'] = cluster_nodes.to_a.join(',')

# set minimum_master_nodes to n/2+1 to avoid split brain scenarios
node.default['elasticsearch']['discovery']['zen']['minimum_master_nodes'] = (cluster_nodes.length / 2).floor + 1
