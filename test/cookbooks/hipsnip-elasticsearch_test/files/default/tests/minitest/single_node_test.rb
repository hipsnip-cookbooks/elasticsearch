require File.expand_path('../support/helpers', __FILE__)

describe_recipe "hipsnip-elasticsearch_test::single_node_test" do
  include Helpers::CookbookTest

  it "should create user for elasticsearch to run as" do
    user("elasticsearch").must_exist
  end

  it "should create group for elasticsearch to run as" do
    group("elasticsearch").must_exist
  end

  it "should create init file for service" do
    file("/etc/init/elasticsearch.conf").must_exist
  end

  it "should set up the main configuration file" do
    file("/etc/elasticsearch/default/elasticsearch.yml").
      must_exist.
      must_include("node.name: Hip Hopper").
      must_include("http.port: 9200").
      must_include("path.conf: /etc/elasticsearch/default").
      must_include("path.data: /var/lib/elasticsearch_data/default").
      must_include("path.logs: /var/log/elasticsearch/default")
  end

  it "should set up the logging configuration file" do
    file("/etc/elasticsearch/default/logging.yml").
      must_exist.
      must_include("rootLogger: INFO, console, file")
  end

  it "should install the Paramedic plugin" do
    file("/usr/local/elasticsearch/plugins/paramedic/_site/index.html").must_exist.with(:owner, 'elasticsearch')
  end

  it "should start the Elasticsearch instance" do
    service("elasticsearch").must_be_running
  end
end