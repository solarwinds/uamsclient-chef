# Managed locally agent operations

# Define the local config template path block
ruby_block 'Set template path' do
  block do
    node.run_state['template_path'] = node['uamsclient']['local_config_template'] || 'templates/template_local_config.yaml.erb'
  end
  action :run
end

# Log the local configuration file path
log 'Log template path' do
  message lazy { "Local configuration file path: #{node.run_state['template_path']}" }
  level :info
end

# Define the block for creating local_config.yaml on Linux systems
ruby_block 'Create local_config.yaml on Linux' do
  block do
    if node['os'] == 'linux'
      template '/opt/solarwinds/uamsclient/var/local_config.yaml' do
        source lazy { node.run_state['template_path'] }
        mode '0644'
#         owner 'root'
#         group 'root'
        action :create
      end
    end
  end
  action :run
end

# Define the block for creating local_config.yaml on Windows systems
ruby_block 'Create local_config.yaml on Windows' do
  block do
    if platform_family?('windows')
      template 'C:\\ProgramData\\SolarWinds\\UAMSClient\\local_config.yaml' do
        source lazy { node.run_state['template_path'] }
        mode '0644'
        action :create
      end
    end
  end
  action :run
end
