actions :run
default_action :run

attribute :node_ip, :kind_of => String, :name_attribute => true
attribute :port, :kind_of => Integer, :default => 9200
attribute :expected_status, :kind_of => String, :default => 'yellow'