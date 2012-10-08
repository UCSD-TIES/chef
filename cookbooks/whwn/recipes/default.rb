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

group "whwn" do
end

user "whwn" do
  comment "Regular User"
  gid "whwn"
  shell "/bin/bash"
  home "/home/whwn"
end

directory "#{%x[echo $HOME].gsub("\n", '')}/.env" do
  owner "whwn"
  group "whwn"
  mode 0775
  action :create
end

python_virtualenv "#{%x[echo $HOME].gsub("\n", '')}/.env" do
  interpreter "python2.7"
  owner "whwn"
  group "whwn"
  action :create
end

include_recipe "sqlite::spatialite"
