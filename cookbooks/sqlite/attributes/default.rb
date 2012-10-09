#
# Cookbook Name:: sqlite
# Attributes:: default
#
# Author:: Jon Wong <j@jnwng.com>
#

include_attribute 'whwn'

# SQLite versions go like 3XXYYZZ
# So 3.7.4 = 3071400
default['sqlite']['version'] = '3071400'
default['sqlite']['checksum'] = '6464d429b1396a8db35864e791673b65'

default['readosm']['version'] = '1.0.0a'
default['readosm']['checksum'] = '2a29279e131150777a94f0900692e569'
default['readosm']['name'] = "readosm-#{default['readosm']['version']}"
default['readosm']['url'] =
  "http://www.gaia-gis.it/gaia-sins/readosm-sources/" +
  "#{default['readosm']['name']}.tar.gz"

default['libspatialite']['version'] = '3.0.1'
default['libspatialite']['checksum'] = 'df7f0f714c2de1dc2791ddef6e8eaba5'
default['libspatialite']['name'] =
  "libspatialite-#{default['libspatialite']['version']}"
default['libspatialite']['url'] = 
  "http://www.gaia-gis.it/gaia-sins/libspatialite-sources/" +
  "#{default['libspatialite']['name']}.tar.gz"

default['spatialite-tools']['version'] = '3.1.0'
default['spatialite-tools']['checksum'] = '9e202b49fa650677be7a59ead888ddec'
default['spatialite-tools']['name'] =
  "spatialite-tools-#{default['spatialite-tools']['version']}"
default['spatialite-tools']['url'] =
  "http://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/" +
  "#{default['spatialite-tools']['name']}.tar.gz"

default['pysqlite']['version'] = '2.6.3'
default['pysqlite']['checksum'] = '711afa1062a1d2c4a67acdf02a33d86e'
default['pysqlite']['name'] = "pysqlite-#{default['pysqlite']['version']}"
default['pysqlite']['url'] = 
  "http://pysqlite.googlecode.com/files/#{default['pysqlite']['name']}.tar.gz"



