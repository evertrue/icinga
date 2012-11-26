#
# Cookbook Name:: icinga
# Recipe:: _server_install_check_mk_source
#
# Copyright 2012, BigPoint GmbH
#
# All rights reserved - Do Not Redistribute
#

# Install Icinga Check_mk Server extensions from source

# Version alias for check_mk
version = node['check_mk']['version']

# Source of check_mk
remote_file "#{Chef::Config[:file_cache_path]}/check_mk-#{version}.tar.gz" do
  source "#{node["check_mk"]["url"]}/check_mk-#{version}.tar.gz"
  mode "0644"
  checksum node["check_mk"]["source"]["tar"]["checksum"] # A SHA256 (or portion thereof) of the file.
  action :create_if_missing
  notifies :create, "template[/root/.check_mk_setup.conf]", :immediately
end

# Add the setup template to compile check_mk
template "/root/.check_mk_setup.conf" do
  action :nothing
  source "check_mk/server/check_mk_setup.conf.erb"
  owner 'root'
  group 'root'
  mode 0640
  only_if { platform_family?("debian") }
  notifies :run, "bash[build_check_mk]", :immediately
end

bash "build_check_mk" do
  action :nothing
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    tar -xzf check_mk-#{version}.tar.gz
    (cd check_mk-#{version} && echo OK)
    (cd check_mk-#{version} && ./setup.sh --yes)
    # Add www-data to Nagios group (Better in chef?)
    usermod -G nagios www-data
  EOF
end
