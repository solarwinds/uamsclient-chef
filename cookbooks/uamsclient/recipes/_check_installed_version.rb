ruby_block 'Evaluate command to get installed version' do
  block do
    if platform_family?('windows')
      command_if_uams_installed = '"C:\\Program Files\\SolarWinds\\UAMSClient\\uamsclient.exe" version'
    else
      if node.run_state['package_manager'] == 'apt'
        command_if_uams_installed = "dpkg-query -l uamsclient | tail -n1 | awk '{print $3}' | cut -d- -f1"
      elsif node.run_state['package_manager'] == 'yum'
        command_if_uams_installed = "yum list | grep uamsclient | awk '{print $2}' | cut -f1 -d-"
      elsif node.run_state['package_manager'] == 'dnf'
        command_if_uams_installed = "dnf list --installed | grep uams | awk '{print $2}' | cut -f1 -d-"
      end
    end
    node.run_state['command_if_uams_installed'] = command_if_uams_installed
  end
  action :run
end

ruby_block 'Get installed version' do
  block do
    node.run_state['installed_version'] = shell_out(node.run_state['command_if_uams_installed']).stdout.chomp
  end
  action :run
end

