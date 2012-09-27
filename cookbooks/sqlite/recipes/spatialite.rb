#
# Cookbook Name:: sqlite
# Recipe:: spatialite
#

# https://docs.djangoproject.com/en/dev/ref/contrib/gis/install/#create-spatialite-db

class Chef::Recipe
  include HelperLib
end

require_recipe "sqlite"
require_recipe "geos"
include_recipe "python::pip"

libspatialite = node['libspatialite']['name']
spatialite_tools = node['spatialite-tools']['name']
pysqlite = node['pysqlite']['name']
freexl = node['freexl']['name']
readosm = node['readosm']['name']

freexl_install_path = "#{Chef::Config[:file_cache_path]}/#{freexl}"
readosm_install_path = "#{Chef::Config[:file_cache_path]}/#{readosm}"
libspatialite_install_path =
  "#{Chef::Config[:file_cache_path]}/#{libspatialite}"
spatialite_tools_install_path =
  "#{Chef::Config[:file_cache_path]}/#{spatialite_tools}"
pysqlite_install_path = "#{Chef::Config[:file_cache_path]}/#{pysqlite}"

# FreeXL (needed for the other tools)
remote_file "#{freexl_install_path}.tar.gz" do
  source node['freexl']['url']
  checksum node['freexl']['checksum']
end

bash "install_freexl" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf #{freexl}.tar.gz
    (cd #{freexl} && ./configure && make && make install)
  EOH
  not_if { ::HelperLib.lib_exists('freexl') }
end

#ReadOSM (Dependency)
remote_file "#{readosm_install_path}.tar.gz" do
  source node['readosm']['url']
  checksum node['readosm']['checksum']
end

bash "install_readosm" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf #{readosm_install_path}.tar.gz
    (cd #{readosm} && ./configure && make && make install)
  EOH
  not_if { ::HelperLib.lib_exists('readosm') }
end

# libspatialite
remote_file "#{libspatialite_install_path}.tar.gz" do
  source node['libspatialite']['url']
  checksum node['libspatialite']['checksum']
  not_if { ::File.exists?("#{libspatialite_install_path}.tar.gz") }
end

bash "install_libspatialite" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf #{libspatialite}.tar.gz
    (cd #{libspatialite} && ./configure && make && make install)
  EOH
  not_if { ::HelperLib.lib_exists('spatialite') }
end

# Spatialite Tools
remote_file "#{spatialite_tools_install_path}.tar.gz" do
  source node['spatialite-tools']['url']
  checksum node['spatialite-tools']['checksum']
  not_if { ::File.exists?("#{spatialite_tools_install_path}.tar.gz") }
end

bash "install_spatialite_tools" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf #{spatialite_tools}.tar.gz
    (cd #{spatialite_tools} && ./configure && make && make install)
  EOH
end

# PySQLite
remote_file "#{pysqlite_install_path}.tar.gz" do
  source node['pysqlite']['url'] 
  checksum node['pysqlite']['checksum']
  not_if { ::File.exists?("#{pysqlite_install_path}.tar.gz") }
end

bash "open_pysqlite" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf #{pysqlite}.tar.gz
  EOH
end

# Need to setup a special setup config
template "#{Chef::Config[:file_cache_path]}/#{pysqlite}/setup.cfg" do
  source "setup.cfg"
  mode   "0755"
end

python_pip "pysqlite" do
  action :install
  not_if { 
    %x[python -c 'from pysqlite2 import dbapi2; print dbapi2.version'].
      include? node['pysqlite']['version']
  }
end
