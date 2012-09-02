#
# Cookbook Name:: postgresql
# Recipe:: postgis
#

require_recipe "postgresql"

execute "setup ppa apt repository" do
  command "add-apt-repository ppa:ubuntugis/ubuntugis-unstable && apt-get update"
  not_if  "test -f /etc/apt/sources.list.d/ubuntugis-ubuntugis-unstable-#{node["lsb"]["codename"]}.list"
end

packages = ["libxml2-dev", "libgeos-dev", "libproj-dev", "libgdal-dev", "make"]

packages.each do |dev_pkg|
    package dev_pkg
end

install_path = "#{Chef::Config[:file_cache_path]}/postgis-#{node['postgis']['version']}"

remote_file "#{install_path}.tar.gz" do
  source "http://postgis.refractions.net/download/postgis-#{node['postgis']['version']}.tar.gz"
  checksum node['postgis']['checksum']
  not_if { ::File.exists?(install_path) }
end

bash "install_postgis" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf postgis-#{node['postgis']['version']}.tar.gz
    (cd postgis-#{node['postgis']['version']}/ && ./configure && make && make install)
  EOH
  not_if { ::File.exists?(install_path) }
end

bash "configure postgis" do
    template_name = "template_postgis"
    pg_postgis = "/usr/share/postgresql/#{node['postgresql']['version']}/contrib/postgis-1.5/postgis.sql"
    pg_spatial_ref = "/usr/share/postgresql/#{node['postgresql']['version']}/contrib/postgis-1.5/spatial_ref_sys.sql"
    user "postgres"
    code <<-EOH
    createdb -h localhost -l en_US.utf8 -T template0 -O postgres -U postgres -E UTF8 #{template_name}
    createlang plpgsql -h localhost -U postgres -d #{template_name}

    psql -h localhost -q -d #{template_name} -f #{pg_postgis}
    psql -h localhost -q -d #{template_name} -f #{pg_spatial_ref}
    EOH
    only_if { `psql -U postgres -h localhost -t -c "select count(*) from pg_catalog.pg_database where datname = '#{template_name}'"`.include? '0'}
end
