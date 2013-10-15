#
# Cookbook Name:: hipsnip-elasticsearch
# Attributes:: default
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

################################################################################
# Download and install

default['elasticsearch']['download']['version'] = '0.90.5'
default['elasticsearch']['download']['checksum'] = 'f14ff217039b5c398a9256b68f46a90093e0a1e54e89f94ee6a2ee7de557bd6d' # SHA-256
# don't change this, unless you're running your own download server
default['elasticsearch']['download']['host'] = 'download.elasticsearch.org'
default['elasticsearch']['download']['subfolder'] = 'elasticsearch/elasticsearch'


################################################################################
# Generic configuration (will be the same for all instances on this node)

default['elasticsearch']['user'] = 'elasticsearch'
default['elasticsearch']['group_id'] = 3900
default['elasticsearch']['group'] = 'elasticsearch'

# Paths
default['elasticsearch']['path']['conf'] = '/etc/elasticsearch'
default['elasticsearch']['path']['data'] = '/var/lib/elasticsearch_data'
default['elasticsearch']['path']['logs'] = '/var/log/elasticsearch'
default['elasticsearch']['path']['install'] = '/usr/local'

# Plugins
default['elasticsearch']['plugins'] = {}

# Cluster
default['elasticsearch']['cluster']['name'] = 'elasticsearch'
default['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = true
default['elasticsearch']['discovery']['zen']['minimum_master_nodes'] = 1
default['elasticsearch']['gateway']['type'] = 'local'
default['elasticsearch']['gateway']['expected_nodes'] = 1

# Index
default['elasticsearch']['index']['mapper']['dynamic'] = true
default['elasticsearch']['action']['auto_create_index'] = true
default['elasticsearch']['action']['disable_delete_all_indices'] = true
default['elasticsearch']['node']['max_local_storage_nodes'] = 1

# Memory
allocated_memory = "#{(node['memory']['total'].to_i * 0.6 ).floor / 1024}m"
default['elasticsearch']['allocated_memory'] = allocated_memory

# Additional JVM settings
default['elasticsearch']['thread_stack_size'] = "256k"
default['elasticsearch']['env_options'] = ""
default['elasticsearch']['gc_settings'] =<<-CONFIG
  -XX:+UseParNewGC
  -XX:+UseConcMarkSweepGC
  -XX:CMSInitiatingOccupancyFraction=75
  -XX:+UseCMSInitiatingOccupancyOnly
  -XX:+HeapDumpOnOutOfMemoryError
CONFIG

# Limits
default['elasticsearch']['bootstrap']['mlockall'] = false # Set to True at your own risk!
default['elasticsearch']['limits']['memlock'] = 'unlimited'
default['elasticsearch']['limits']['nofile']  = 64000

# Freestyle custom config
default['elasticsearch']['custom_config'] = {}

# Logging
default['elasticsearch']['logging']['syslog'] = false
default['elasticsearch']['logging']['level'] = 'INFO'
default['elasticsearch']['logging']['params']['action'] = 'DEBUG'
default['elasticsearch']['logging']['params']['com.amazonaws'] = 'WARN'


################################################################################
# Settings for node health check provider

default['elasticsearch']['node_check']['expected_status'] = 'yellow'
default['elasticsearch']['node_check']['retries'] = 3
default['elasticsearch']['node_check']['timeout'] = 10 # seconds
# @note - timeout is exponential - the actual timeout is retry*timeout
