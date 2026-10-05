docs_url = 'https://documentation.solarwinds.com/en/success_center/observability/content/system_requirements/agent_requirements.htm'

default['uamsclient_uninstall']['product_name'] = 'SolarWinds UAMS Client'
default['uamsclient_uninstall']['agent_requirements_docs_url'] = docs_url
default['uamsclient_uninstall']['unsupported_os_msg'] =
  "The #{node['uamsclient_uninstall']['product_name']} does not support your operating system. " \
  "Supported operating systems are defined in the official documentation: #{docs_url}"
default['uamsclient_uninstall']['unsupported_os_version_msg'] =
  'This operating system version is not supported. ' \
  "Supported operating system versions are defined in the official documentation: #{docs_url}"
