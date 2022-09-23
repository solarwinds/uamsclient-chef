# Environment variables
default['uamsclient']['uams_access_token'] = ''
default['uamsclient']['uams_metadata'] = 'role:host-monitoring'
# Installation configuration
default['uamsclient']['local_pkg_path'] = '/tmp/uams'
default['uamsclient']['install_pkg_url'] = 'https://agent-binaries.cloud.solarwinds.com/uams/latest'
default['uamsclient']['remove_installer'] = true
default['uamsclient']['dev_container_test'] = false
