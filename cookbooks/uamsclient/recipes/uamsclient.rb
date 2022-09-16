ruby_block 'Validate inputs' do
  block do
    ['uams_access_token', 'uams_metadata', 'swo_url'].each do |attr_name|
      raise "Attribute #{attr_name} is not set." if node['uamsclient'][attr_name] == ''
    end
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

ENV['UAMS_ACCESS_TOKEN'] = node['uamsclient']['uams_access_token']
ENV['UAMS_METADATA'] = node['uamsclient']['uams_metadata']

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
  only_if { node['uamsclient']['remove_installer'] }
end
