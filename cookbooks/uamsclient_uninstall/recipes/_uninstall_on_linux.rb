apt_package 'uamsclient' do
  action :purge
  only_if { node.run_state['package_manager'] == 'apt' && !node.normal['uamsclient']['dev_container_test'] }
end

apt_package 'uamsclient' do
  action :purge
  ignore_failure true
  only_if { node.run_state['package_manager'] == 'apt' && node.normal['uamsclient']['dev_container_test'] }
end

yum_package 'uamsclient' do
  action :remove
  only_if { (%w(yum).include? node.run_state['package_manager']) }
end

dnf_package 'uamsclient' do
  action :remove
  only_if { (%w(dnf).include? node.run_state['package_manager']) }
end
