
include_recipe "postgresql::postgis"
include_recipe "git::source"

include_recipe "sqlite::spatialite"

package "mercurial"

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

directory "/home/vagrant/.env" do
  owner "whwn"
  group "whwn"
  mode 0775
  action :create
end

python_virtualenv "/home/vagrant/.env" do
  interpreter "python2.7"
  owner "whwn"
  group "whwn"
  action :create
end