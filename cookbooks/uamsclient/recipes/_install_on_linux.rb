directory 'Local path for installer' do
  mode '0755'
  path node['uamsclient']['local_pkg_path']
  recursive true
  action :create
end

ruby_block 'Evaluate installation package filename' do
  block do
    node.run_state['installation_pkg_filename'] = 'uamsclient.' + node.run_state['package_file_extention']
    node.run_state['installation_pkg'] = node['uamsclient']['local_pkg_path'] + '/' + node.run_state['installation_pkg_filename']
  end
  action :run
end

remote_file 'Download installation package' do
  path lazy { node.run_state['installation_pkg'] }
  source lazy { node['uamsclient']['install_pkg_url'] + '/' + node.run_state['installation_pkg_filename'] }
  action :create
end

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

file 'Remove installer' do
  path lazy { "#{node.run_state['installation_pkg']}" }
  action :delete
  only_if { node['uamsclient']['remove_installer'] }
end
