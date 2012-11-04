#
# Cookbook Name:: whwn
# Recipe:: postgis
#

include_recipe "postgresql"
include_recipe "postgresql::server"
include_recipe "postgresql::contrib"
include_recipe "postgresql::libpq"
include_recipe "postgresql::postgis"