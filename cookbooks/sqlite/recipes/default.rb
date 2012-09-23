#
# Cookbook Name:: postgresql
# Recipe:: default
#

install_path = "#{Chef::Config[:file_cache_path]}/sqlite-#{node['sqlite']['version']}"
sqlite = "sqlite-autoconf-#{node['sqlite']['version']}"

remote_file "#{install_path}.tar.gz" do
  source "http://www.sqlite.org/#{sqlite}.tar.gz"
  checksum node['sqlite']['checksum']
  not_if { ::File.exists?("#{install_path}.tar.gz") }
end

# We need to set a special flag to enable r tree in sqlite
# We also want to make sure to overwrite the system lib sqlite
bash "install_sqlite" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf #{sqlite}.tar.gz
    (cd #{sqlite} && CFLAGS="-DSQLITE_ENABLE_RTREE=1" ./configure --prefix=/usr && make && make install)
  EOH
end