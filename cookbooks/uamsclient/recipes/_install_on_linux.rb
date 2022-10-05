execute 'Install UAMS Client with apt' do
  command lazy { "dpkg -i #{node.run_state['installation_pkg']}" }
  action :run
  only_if { node.run_state['install_new_version'] && node.run_state['package_manager'] == 'apt' && !node['uamsclient']['dev_container_test'] }
end

execute 'Install UAMS Client with apt - in container' do
  command lazy { "apt install -y #{node.run_state['installation_pkg']}" }
  action :run
  ignore_failure true
  only_if { node.run_state['install_new_version'] && node.run_state['package_manager'] == 'apt' && node['uamsclient']['dev_container_test'] }
end

package 'Install UAMS Client with dnf/yum' do
  package_name lazy { "#{node.run_state['installation_pkg']}" }
  action :install
  only_if { node.run_state['install_new_version'] && (%w(dnf yum).include? node.run_state['package_manager']) }
end
