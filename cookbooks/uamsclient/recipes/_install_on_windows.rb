package 'Install UAMS Client with msi' do
  package_name 'SolarWinds UAMS Client'
  source lazy { "#{node.run_state['installation_pkg']}" }
  options "ACCESSTOKEN=#{node['uamsclient']['uams_access_token']} METADATA=#{node['uamsclient']['uams_metadata']}"
  action :install
end
