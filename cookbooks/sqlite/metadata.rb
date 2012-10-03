name             "sqlite"
maintainer       "Jon Wong"
maintainer_email "j@jnwng.com"
description      "Installs SQLite"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          "0.1.0"

recipe "sqlite",           "Set up the apt repository and install dependent packages"
recipe "sqlite::spatialite",   "Front-end programs for PostgreSQL 9.x"

supports "ubuntu"
