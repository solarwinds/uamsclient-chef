ruby_block 'Validate inputs' do
  block do
    raise 'Attribute uams_access_token is not set.' if node['uamsclient']['uams_access_token'] == ''
    raise 'Attribute uams_metadata is not set.' if node['uamsclient']['uams_metadata'] == ''
  end
  action :run
end

ruby_block 'Check OS support' do
  block do
    isVersionSuported = true
    majorPlatformVersionString, = node['platform_version'].split('.')
    majorPlatformVersion = majorPlatformVersionString.to_i
    case node['platform']
    when 'debian'
      if majorPlatformVersion < 9
        isVersionSuported = false
      end
    when 'ubuntu'
      if majorPlatformVersion < 18
        isVersionSuported = false
      end
    when 'redhat'
      if majorPlatformVersion < 7
        isVersionSuported = false
      end
    when 'centos'
      if majorPlatformVersion < 7
        isVersionSuported = false
      end
    when 'fedora'
      if majorPlatformVersion < 32
        isVersionSuported = false
      end
    when 'kali'
      if majorPlatformVersion < 2021
        isVersionSuported = false
      end
    when 'oracle'
      if majorPlatformVersion < 8
        isVersionSuported = false
      end
    when 'windows'
      if majorPlatformVersion < 10
        isVersionSuported = false
      end
    else
      raise "Platform #{node['platform']} is not supported by UAMS Client."
    end

    unless isVersionSuported
      raise "Platform (#{node['platform']}) version #{node['platform_version']} is not supported."
    end
    node.run_state['major_platform_version'] = majorPlatformVersion
  end
  action :run
end

ruby_block 'Evaluate package manager for platform' do
  block do
    if platform_family?('debian')
      packageManager = 'apt'
      installPackageExtention = 'deb'
    elsif platform_family?('windows')
      packageManager = 'msi'
      installPackageExtention = 'msi'
    elsif platform_family?('rhel', 'fedora')
      installPackageExtention = 'rpm'
      packageManager = if platform?('fedora', 'oracle') ||
                          (platform?('centos') && node.run_state['major_platform_version'] > 7) ||
                          (platform?('redhat') && node.run_state['major_platform_version'] > 7)
                         'dnf'
                       else
                         'yum'
                       end
    else
      raise "Can't evaluate package manager for given platform - #{node['platform']}."
    end
    node.run_state['package_manager'] = packageManager
    node.run_state['package_file_extention'] = installPackageExtention
  end
  action :run
end

include_recipe '::_check_available_version'
include_recipe '::_check_installed_version'

ruby_block 'Evaluate if new version should be installed' do
  block do
    node.run_state['install_new_version'] = false
    puts # empty line
    puts "Installed version: #{node.run_state['installed_version']}"
    puts "Available version: #{node.run_state['available_version']}"
    if node.run_state['installed_version'] == '' || Gem::Version.new(node.run_state['available_version']) > Gem::Version.new(node.run_state['installed_version'])
      puts 'Proceed with installation.'
      node.run_state['install_new_version'] = true
    else
      puts 'Skipping installation.'
    end
  end
  action :run
end

ENV['UAMS_ACCESS_TOKEN'] = node['uamsclient']['uams_access_token']
ENV['UAMS_METADATA'] = node['uamsclient']['uams_metadata']
ENV['SWO_URL'] = 'https://dummy'

directory 'Local path for installer' do
  mode '0755'
  path node['uamsclient']['local_pkg_path']
  recursive true
  action :create
  only_if { node.run_state['install_new_version'] }
end

ruby_block 'Evaluate installation package filename' do
  block do
    node.run_state['installation_pkg_filename'] = 'uamsclient.' + node.run_state['package_file_extention']
    node.run_state['installation_pkg'] = node['uamsclient']['local_pkg_path'] + '/' + node.run_state['installation_pkg_filename']
  end
  action :run
  only_if { node.run_state['install_new_version'] }
end

remote_file 'Download installation package' do
  path lazy { node.run_state['installation_pkg'] }
  source lazy { node['uamsclient']['install_pkg_url'] + '/' + node.run_state['installation_pkg_filename'] }
  action :create
  only_if { node.run_state['install_new_version'] }
end

if node['os'] == 'linux'
  include_recipe '::_install_on_linux'
elsif platform_family?('windows')
  include_recipe '::_install_on_windows'
else
  raise "No installation recipe matches your OS: #{node['os']}"
end

file 'Remove installer' do
  path lazy { "#{node.run_state['installation_pkg']}" }
  action :delete
  only_if { node['uamsclient']['remove_installer'] && node.run_state['install_new_version'] }
end
