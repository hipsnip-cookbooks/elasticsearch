#
# Cookbook Name:: hipsnip-elasticsearch
# Provider:: instance
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

action :create do
  instance_name = if new_resource.name == "default" then "elasticsearch"
                  else "elasticsearch-#{new_resource.name}"
                  end

  Chef::Log.info "Configuring Elasticsearch instance '#{instance_name}'..."

  config_dir = ::File.join(node['elasticsearch']['path']['conf'], new_resource.name)
  data_dir = ::File.join(node['elasticsearch']['path']['data'], new_resource.name)
  log_dir = ::File.join(node['elasticsearch']['path']['logs'], new_resource.name)

  directory config_dir do
    mode  '755'
    owner 'root'
    group 'root'
  end

  directory data_dir do
    owner node['elasticsearch']['user']
    group node['elasticsearch']['group']
    mode  '755'
    recursive true
  end

  directory log_dir do
    owner node['elasticsearch']['user']
    group node['elasticsearch']['group']
    mode  '755'
    recursive true
  end

  template "#{config_dir}/elasticsearch.yml" do
    source "elasticsearch.yml.erb"
    mode '644'
    cookbook 'hipsnip-elasticsearch'
    variables({
      'node_name' => new_resource.node_name,
      'port' => new_resource.port,
      'config_dir' => config_dir,
      'data_dir' => data_dir,
      'log_dir' => log_dir
    })

    notifies :restart, "service[#{instance_name}]"
  end

  template "#{config_dir}/logging.yml" do
    source "logging.yml.erb"
    mode '644'
    cookbook 'hipsnip-elasticsearch'

    notifies :restart, "service[#{instance_name}]"
  end

  # Install Plugins
  plugin_dir = "#{node['elasticsearch']['path']['install']}/elasticsearch-#{node['elasticsearch']['download']['version']}/plugins/"

  node['elasticsearch']['plugins'].each do |name, params|
    ruby_block "Install plugin '#{name}' for instance '#{instance_name}'" do
      block do
        version = params['version'] ? "/#{params['version']}" : nil
        url     = params['url']     ? " -url #{params['url']}" : nil

        command = "/usr/local/bin/plugin -install #{name}#{version}#{url}"
        Chef::Log.debug command

        raise "[!] Failed to install plugin" unless system command
        raise "[!] Failed to set permission" unless system "chown -R #{node['elasticsearch']['user']}:#{node['elasticsearch']['group']} #{plugin_dir}"
      end

      notifies :restart, 'service[#{instance_name}]'

      not_if do
        Dir.entries(plugin_dir).any? do |plugin|
          next if plugin =~ /^\./
          name.include? plugin
        end rescue false
      end
    end
  end

  # Upstart script
  template "/etc/init/#{instance_name}.conf" do
    source "elasticsearch.upstart.erb"
    mode '644'
    cookbook 'hipsnip-elasticsearch'
    variables({
      'config_dir' => config_dir,
      'instance_name' => instance_name
    })

    notifies :restart, "service[#{instance_name}]"
  end

  service instance_name do
    provider Chef::Provider::Service::Upstart
    action [:enable, :start]
  end

  hipsnip_elasticsearch_check_node "127.0.0.1" do
    port new_resource.port
    expected_status node['elasticsearch']['node_check']['expected_status']
  end

  new_resource.updated_by_last_action(true)
end