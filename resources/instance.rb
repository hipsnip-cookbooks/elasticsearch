actions :create
default_action :create

attribute :port, :kind_of => Integer, :default => 9200
attribute :node_name, :kind_of => String, :default => 'My Node'