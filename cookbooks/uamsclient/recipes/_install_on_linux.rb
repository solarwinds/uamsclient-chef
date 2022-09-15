execute 'Install UAMS Client with apt' do
  command lazy { "apt install -y #{node.run_state['installation_pkg']}" }
  action :run
  only_if { node.run_state['package_manager'] == 'apt' }
end

package 'Install UAMS Client with dnf/yum' do
  package_name lazy { "#{node.run_state['installation_pkg']}" }
  action :install
  only_if { %w(dnf yum).include? node.run_state['package_manager'] }
end
