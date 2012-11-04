group "whwn" do
end

user "whwn" do
  comment "Regular User"
  gid "whwn"
  shell "/bin/bash"
  home "/home/whwn"
end

directory "/tmp/whwn" do
  owner "whwn"
  group "whwn"
  mode 0775
  action :create
end

include_recipe "apt"
package "g++"
package "mercurial"

include_recipe "git::source"
include_recipe "python"

directory node['whwn']['virtualenv'] do
  owner "whwn"
  group "whwn"
  mode 0775
  action :create
  recursive true
end

python_virtualenv node['whwn']['virtualenv'] do
  interpreter "python2.7"
  owner "whwn"
  group "whwn"
  action :create
end

include_recipe "sqlite::spatialite"
