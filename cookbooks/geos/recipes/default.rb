
package "make" 

geos = node['geos']['name']
geos_install_path = "#{Chef::Config[:file_cache_path]}/#{geos}.tar.bz2"

remote_file geos_install_path do
  source node['geos']['url']
  checksum node['geos']['checksum']
  not_if { ::HelperLib.lib_exists('geos') }
end

bash "install_geos" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -xjf #{geos}.tar.bz2
    (cd #{geos}/ && ./configure && make && make install)
  EOH
  not_if { ::HelperLib.lib_exists('geos') }
end