#
# Cookbook Name:: whwn
# Recipe:: postgis
#

include_recipe "apt"
package "g++"

include_recipe "postgresql"
include_recipe "postgresql::server"
include_recipe "postgresql::contrib"
include_recipe "postgresql::libpq"
include_recipe "postgresql::postgis"

pg_user "whwn" do
  privileges :superuser => true, :createdb => false, :login => true
  password "whwn2012"
end

pg_database "whwn" do
  owner "whwn"
  encoding "utf8"
  template "template_postgis"
end