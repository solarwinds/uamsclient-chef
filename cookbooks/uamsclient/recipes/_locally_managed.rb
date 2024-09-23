# Managed locally agent operations

# Define the local config template path block
ruby_block 'SSSSSS Set template path' do
  block do
    user_path = node['uamsclient']['local_config_template']
    if user_path.nil? || user_path.empty?
      node.run_state['template_path'] = 'templates/local_config.yaml.erb'
    else
      node.run_state['template_path'] = user_path
    end
    Chef::Log.info("TTTTTTTT Template Path: #{node.run_state['template_path']}")
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
