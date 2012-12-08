
package "nginx"

user node[:nginx][:user] do
  comment "Nginx User"
  system true
  shell "/bin/false"
  action :create
end
group node[:nginx][:user] do
  members node[:nginx][:user]
  action :create
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

directory node[:nginx][:log_dir] do
  mode 0755
  owner 'root'
  action :create
end

template "#{node[:nginx][:dir]}/sites-available/whwn.conf" do
  source "nginx.conf"
  owner  "root"
  group  "root"
  mode   "0644"
  if File.exists?("#{node[:nginx][:dir]}/sites-enabled/whwn.conf")
    notifies :restart, 'service[nginx]'
  end
end

nginx_site "whwn.conf" do
  enable true
end