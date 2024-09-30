# Managed locally agent operations

# Define the local config template path block
ruby_block 'Set template path' do
  block do
    node.run_state['template_path'] = 'templates/local_config.yaml.erb'
    Chef::Log.info("Template Path: #{node.run_state['template_path']}")
  end
  action :run
end

template "/opt/solarwinds/uamsclient/var/local_config.yaml" do
  source node.run_state['template_path']
  mode "0644"
  owner 'swagent'
  group 'swagent'
  variables(
  :local_config => node['uamsclient']['local_config']
  )
  only_if { node['os'] == 'linux' }
end

template "C:\\ProgramData\\SolarWinds\\UAMSClient\\local_config.yaml" do
  source node.run_state['template_path']
  variables(
  :local_config => node['uamsclient']['local_config']
  )
  only_if { platform_family?('windows') }
end
