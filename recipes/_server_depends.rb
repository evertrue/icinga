#
# Cookbook Name:: icinga
# Recipe:: _server_depends
#
# Copyright 2012, BigPoint GmbH
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Needed to build check_mk from source (no debian package available)
include_recipe 'build-essential'

# Install Apache2
include_recipe 'apache2'

# Install for mod_ssl
package 'ca-certificates'
package 'ssl-cert'

# Apache2 Modules
include_recipe 'apache2::mod_ssl'
include_recipe 'apache2::mod_python'

# Enable default vhosts
apache_site 'default-ssl'
apache_site 'default'
