name             "hipsnip-elasticsearch"
maintainer       "HipSnip Ltd."
maintainer_email "adam@hipsnip.com"
license          "Apache 2.0"
description      "Installs/Configures Elasticsearch"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"
supports 'ubuntu', ">= 12.04"

depends "ark", ">= 0.4.0"
depends "java", ">= 1.14.0"
depends "sysctl", ">= 0.3.2"

recipe "hipsnip-elasticsearch", "Downloads and unpacks the required version of Elasticsearch - does not set up an instance"