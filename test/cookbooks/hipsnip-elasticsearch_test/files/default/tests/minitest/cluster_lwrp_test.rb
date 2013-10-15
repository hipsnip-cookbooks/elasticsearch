require File.expand_path('../support/helpers', __FILE__)

describe_recipe "hipsnip-elasticsearch_test::cluster_lwrp_test" do
  include Helpers::CookbookTest

  it "should create user for elasticsearch to run as" do
    user("elasticsearch").must_exist
  end

  it "should create group for elasticsearch to run as" do
    group("elasticsearch").must_exist
  end

  it "should create init file for service 'one'" do
    file("/etc/init/elasticsearch-one.conf").must_exist
  end

  it "should create init file for service 'two'" do
    file("/etc/init/elasticsearch-two.conf").must_exist
  end

  it "should set up the configuration file for instance 'one'" do
    file("/etc/elasticsearch/one/elasticsearch.yml").
      must_exist.
      must_include("node.name: one").
      must_include("http.port: 9200").
      must_include("path.conf: /etc/elasticsearch/one").
      must_include("path.data: /var/lib/elasticsearch_data/one").
      must_include("path.logs: /var/log/elasticsearch/one")
  end

  it "should set up the configuration file for instance 'two'" do
    file("/etc/elasticsearch/two/elasticsearch.yml").
      must_exist.
      must_include("node.name: two").
      must_include("http.port: 9201").
      must_include("path.conf: /etc/elasticsearch/two").
      must_include("path.data: /var/lib/elasticsearch_data/two").
      must_include("path.logs: /var/log/elasticsearch/two")
  end

  it "should set up the logging configuration file for instance 'one'" do
    file("/etc/elasticsearch/one/logging.yml").
      must_exist.
      must_include("rootLogger: INFO, console, file")
  end

  it "should set up the logging configuration file for instance 'two'" do
    file("/etc/elasticsearch/two/logging.yml").
      must_exist.
      must_include("rootLogger: INFO, console, file")
  end

  it "should start Elasticsearch instance" do
    service("elasticsearch").must_be_running
  end
end