windows_package 'Uninstall UAMS Client package' do
  source 'SolarWinds UAMS Client'
  options 'DELETE_ALL_CONFIGURATION=1'
  package_name 'SolarWinds UAMS Client'
  action :remove
end
