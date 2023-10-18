package 'Install UAMS Client with msi' do
  package_name 'SolarWinds UAMS Client'
  source lazy { "#{node.run_state['installation_pkg']}" }
  options "ACCESSTOKEN=#{node['uamsclient']['uams_access_token']} METADATA=#{node['uamsclient']['uams_metadata']} SWO_URL=#{node['uamsclient']['swo_url']} HTTPS_PROXY=#{node['uamsclient']['uams_https_proxy']}"
  action :install
  only_if { node.run_state['install_new_version'] }
end
