actions :create
default_action :create

attribute :http_port, :kind_of => Integer, :default => node['elasticsearch']['http']['port']
attribute :tcp_port, :kind_of => Integer, :default => node['elasticsearch']['transport']['tcp']['port']
attribute :node_name, :kind_of => String, :default => 'Hip Hopper'