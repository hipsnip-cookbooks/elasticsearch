#
# Cookbook Name:: hipsnip-elasticsearch
# Provider:: check_node
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

action :run do
    node_ip = new_resource.node_ip
    port = new_resource.port
    expected_status = new_resource.expected_status

    Chef::Log.info "Checking Elasticsearch node at #{node_ip}:#{port}"

    retries = 0

    until system("curl --silent --show-error 'http://#{node_ip}:#{port}?wait_for_status=#{expected_status}&timeout=5s'")
      if retries < node['elasticsearch']['node_check']['retries']
        retries += 1
        sleep_time = retries * node['elasticsearch']['node_check']['timeout']

        Chef::Log.info "Waiting #{sleep_time} seconds and retrying..."
        sleep(sleep_time)
      else
        raise "Elasticsearch node at #{node_ip}:#{port} is not available with status '#{expected_status}'"
      end
    end

    Chef::Log.info "Elasticsearch node at #{node_ip}:#{port} is alive and well!"

    new_resource.updated_by_last_action(true)
end