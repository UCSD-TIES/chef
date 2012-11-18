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

execute "setup ppa apt repository ubuntugis" do
  command "add-apt-repository ppa:ubuntugis/ubuntugis-unstable && apt-get update"
  not_if  "test -f /etc/apt/sources.list.d/ubuntugis-ubuntugis-unstable-#{node["lsb"]["codename"]}.list"
end

packages = ["libproj-dev", "libgdal-dev", "libfreexl-dev", "libexpat1-dev", "make"]
packages.each {|pkg| package pkg}

libspatialite = node['libspatialite']['name']
spatialite_tools = node['spatialite-tools']['name']
pysqlite = node['pysqlite']['name']
readosm = node['readosm']['name']

readosm_install_path = "#{Chef::Config[:file_cache_path]}/#{readosm}"
libspatialite_install_path =
  "#{Chef::Config[:file_cache_path]}/#{libspatialite}"
spatialite_tools_install_path =
  "#{Chef::Config[:file_cache_path]}/#{spatialite_tools}"
pysqlite_install_path = "#{Chef::Config[:file_cache_path]}/#{pysqlite}"

#ReadOSM (Dependency)
remote_file "#{readosm_install_path}.tar.gz" do
  source node['readosm']['url']
  checksum node['readosm']['checksum']
  not_if { ::File.exists?('/usr/local/lib/libreadosm.so') }
end

bash "install_readosm" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf #{readosm_install_path}.tar.gz
    (cd #{readosm} && ./configure && make && make install)
  EOH
  not_if { ::File.exists?('/usr/local/lib/libreadosm.so') }
end

# libspatialite
remote_file "#{libspatialite_install_path}.tar.gz" do
  source node['libspatialite']['url']
  checksum node['libspatialite']['checksum']
  not_if { ::HelperLib.lib_exists('spatialite') }
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
  not_if { ::File.exists?("/usr/local/bin/spatialite_tool") }
end

bash "install_spatialite_tools" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf #{spatialite_tools}.tar.gz
    (cd #{spatialite_tools} && ./configure && make && make install)
  EOH
  not_if { ::File.exists?("/usr/local/bin/spatialite_tool") }
end

# PySQLite
remote_file "#{pysqlite_install_path}.tar.gz" do
  source node['pysqlite']['url'] 
  checksum node['pysqlite']['checksum']
  not_if {
    ::File.directory?(
      "#{node['whwn']['virtualenv']}/lib/python2.7/site-packages/pysqlite2"
    )
  }
end

bash "open_pysqlite" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf #{pysqlite}.tar.gz
  EOH
  not_if {
    ::File.directory?(
      "#{node['whwn']['virtualenv']}/lib/python2.7/site-packages/pysqlite2"
    )
  }
end

# Need to setup a special setup config
template "#{Chef::Config[:file_cache_path]}/#{pysqlite}/setup.cfg" do
  source "setup.cfg"
  mode   "0755"
  not_if {
    ::File.directory?(
      "#{node['whwn']['virtualenv']}/lib/python2.7/site-packages/pysqlite2"
    )
  }
end

bash "install_pysqlite" do
  user "root"
  cwd pysqlite_install_path
  code <<-EOH
    source #{node['whwn']['virtualenv']}/bin/activate && python setup.py install
  EOH
  not_if {
    ::File.directory?(
      "#{node['whwn']['virtualenv']}/lib/python2.7/site-packages/pysqlite2"
    )
  }
end

#Setting up spatial tables
bash "setup_tables" do
  user "root"
  code <<-EOH
    spatialite geodjango.db "SELECT InitSpatialMetaData();"
  EOH
end
