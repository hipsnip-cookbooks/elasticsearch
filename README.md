Description [![Build Status](https://travis-ci.org/hipsnip-cookbooks/elasticsearch.png)](https://travis-ci.org/hipsnip-cookbooks/elasticsearch)
===========
This is a cookbook for setting up an Elasticsearch cluster with one or more nodes.
You can use the resource providers (see below) for creating your own layout of nodes,
or the recipes to automatically set things up from node attributes.

This cookbook was heavily inspired by the official Elasticsearch cookbook, but takes
a slightly different approach when it comes to setting up individual nodes. If you need
better cross-platform support, or you find there are features missing from here, you'll
want to try the official cookbook: get it from the [Opscode Community](http://community.opscode.com/cookbooks/elasticsearch) site or
the [GitHub repo](https://github.com/elasticsearch/cookbook-elasticsearch).


Compatibility
=============
Integration tested on 64bit Ubuntu `12.04` with Chef `11.6`, but assumed to work with other Debian-based
distros as well.


Usage
=====
On the most basic level, just include the `hipsnip-elasticsearch::node` recipe to set up a single instance,
or the `hipsnip-elasticsearch::cluster` recipe to automatically set up a cluster. These will set sensible
defaults and will work fine out of the box, but you have the ability to customize them
using the attributes below.

> NOTE: The `cluster` recipe will not work with Chef Solo. You can use the resource providers
below to manually build your own cluster, if you don't use Chef Server.