require File.expand_path('../support/helpers', __FILE__)

describe_recipe "hipsnip-elasticsearch_test::single_node_test" do
  include Helpers::CookbookTest

  it "should create init file for service" do
    file("/etc/init/elasticsearch.conf").must_exist
  end
end