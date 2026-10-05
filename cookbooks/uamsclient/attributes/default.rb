# Environment variables
default['uamsclient']['uams_access_token'] = ''
default['uamsclient']['uams_metadata'] = 'role:host-monitoring'
default['uamsclient']['swo_url'] = ''
default['uamsclient']['uams_https_proxy'] = ''
default['uamsclient']['uams_override_hostname'] = ''
default['uamsclient']['uams_managed_locally'] = false

# Installation configuration
default['uamsclient']['local_pkg_path'] = '/tmp/uams'
default['uamsclient']['install_pkg_url'] = 'https://agent-binaries.cloud.solarwinds.com/uams/latest'
default['uamsclient']['remove_installer'] = true
default['uamsclient']['dev_container_test'] = false
default['uamsclient']['ci_test'] = false

# Template variables for local config and credentials config
default['uamsclient']['local_config']['mysql_host'] = 'mysql_test'
default['uamsclient']['local_config']['user'] = 'user_test'
default['uamsclient']['local_config']['secret_name'] = 'secret_name_test'
default['uamsclient']['credentials_config']['access_key_id'] = 'your_access_key_id'
default['uamsclient']['credentials_config']['secret_access_key'] = 'your_access_key_id'

# Supported OS messages
docs_url = 'https://documentation.solarwinds.com/en/success_center/observability/content/system_requirements/agent_requirements.htm'

default['uamsclient']['product_name'] = 'SolarWinds UAMS Client'
default['uamsclient']['agent_requirements_docs_url'] = docs_url
default['uamsclient']['unsupported_os_msg'] =
  "The #{node['uamsclient']['product_name']} does not support your operating system. " \
  "Supported operating systems are defined in the official documentation: #{docs_url}"
default['uamsclient']['unsupported_os_version_msg'] =
  'This operating system version is not supported. ' \
  "Supported operating system versions are defined in the official documentation: #{docs_url}"
