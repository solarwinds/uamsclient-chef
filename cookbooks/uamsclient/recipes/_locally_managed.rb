# Managed locally agent operations

# Define the local config template path block
ruby_block 'Set template path' do
  block do
    node.run_state['template_path'] = 'templates/local_config.yaml.erb'
    Chef::Log.info("Template Path: #{node.run_state['template_path']}")
  end
  action :run
end

# Define the credentials config template path block
ruby_block 'Set credentials template path' do
  block do
    node.run_state['credentials_template_path'] = 'templates/credentials_config.yaml.erb'
    Chef::Log.info("Credentials Template Path: #{node.run_state['credentials_template_path']}")
  end
  action :run
end

template '/opt/solarwinds/uamsclient/var/local_config.yaml' do
  source node.run_state['template_path']
  mode '0660'
  owner 'swagent'
  group 'swagent'
  variables(
    local_config: node['uamsclient']['local_config']
  )
  only_if { node['os'] == 'linux' }
end

template '/opt/solarwinds/uamsclient/var/credentials_config.yaml' do
  source node.run_state['credentials_template_path']
  mode '0660'
  owner 'swagent'
  group 'swagent'
  variables(
    credentials_config: node['uamsclient']['credentials_config']
  )
  only_if { node['os'] == 'linux' }
end

template 'C:\\ProgramData\\SolarWinds\\UAMSClient\\local_config.yaml' do
  source node.run_state['template_path']
  variables(
    local_config: node['uamsclient']['local_config']
  )
  only_if { platform_family?('windows') }
end

template 'C:\\ProgramData\\SolarWinds\\UAMSClient\\credentials_config.yaml' do
  source node.run_state['credentials_template_path']
  variables(
    credentials_config: node['uamsclient']['credentials_config']
  )
  only_if { platform_family?('windows') }
end
