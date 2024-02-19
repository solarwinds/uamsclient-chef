ruby_block 'Check OS support' do
  block do
    isVersionSupported = true
    majorPlatformVersionString, = node['platform_version'].split('.')
    majorPlatformVersion = majorPlatformVersionString.to_i
    case node['platform']
    when 'debian'
      if majorPlatformVersion < 9
        isVersionSupported = false
      end
    when 'ubuntu'
      if majorPlatformVersion < 18
        isVersionSupported = false
      end
    when 'redhat'
      if majorPlatformVersion < 7
        isVersionSupported = false
      end
    when 'centos'
      if majorPlatformVersion < 7
        isVersionSupported = false
      end
    when 'fedora'
      if majorPlatformVersion < 32
        isVersionSupported = false
      end
    when 'kali'
      if majorPlatformVersion < 2021
        isVersionSupported = false
      end
    when 'oracle'
      if majorPlatformVersion < 8
        isVersionSupported = false
      end
    when 'amazon'
      if majorPlatformVersion < 2
        isVersionSupported = false
      end
    when 'rocky'
      if majorPlatformVersion < 8
        isVersionSupported = false
      end
    when 'windows'
      if majorPlatformVersion < 10
        isVersionSupported = false
      end
    else
      raise "Platform #{node['platform']} is not supported by UAMS Client."
    end

    unless isVersionSupported
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
    elsif platform_family?('windows')
      packageManager = 'msi'
    elsif platform_family?('rhel', 'fedora', 'amazon')
      packageManager = if platform?('fedora', 'oracle', 'rocky') ||
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
  end
  action :run
end

if node['os'] == 'linux'
  include_recipe '::_uninstall_on_linux'
elsif platform_family?('windows')
  include_recipe '::_uninstall_on_windows'
else
  raise "No uninstallation recipe matches your OS: #{node['os']}"
end
