#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: python
# Attribute:: default
#
# Copyright 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['python']['install_method'] = 'source'

if python['install_method'] == 'package'
  default['python']['prefix_dir']         = '/usr'
else
  default['python']['prefix_dir']         = '/usr/local'
end

case platform
when "redhat","centos","scientific","fedora","suse","amazon"
  set['python']['pip']['prefix_dir']  = '/usr'
when "debian","ubuntu"
  set['python']['pip']['prefix_dir']  = '/usr/local'
else
  set['python']['pip']['prefix_dir']  = '/usr/local'
end

default['python']['url'] = 'http://www.python.org/ftp/python'
default['python']['version'] = '2.7.3'
default['python']['checksum'] = 'd4c20f2b5faf95999fd5fecb3f7d32071b0820516224a6d2b72932ab47a1cb8e'
default['python']['configure_options'] = %W{--prefix=#{python['prefix_dir']}}

