# Cookbook Name:: uams_client_installator
# Recipe:: default.rb

package "wget" do
   action :install
end

ENV['UAMS_ACCESS_TOKEN'] = node['uams_client_installator']['uams_access_token']

installation_directory = node['uams_client_installator']['uams_install_path']

directory "#{installation_directory}" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

remote_file "#{installation_directory}/uamsclient_install.sh" do
  source 'https://agent-binaries.cloud.solarwinds.com/uams/latest/uamsclient_install.sh'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'Run UAMS Client installation script' do
    command <<-EOH
        cd #{installation_directory}
        sh ./uamsclient_install.sh
    EOH
    live_stream true
    action :run
end
