# UAMS Client Cookbook

The **uamsclient** cookbook is used to deploy and configure UAMS Client (SolarWinds Observability agent).

# Setup

The **uamsclient** cookbook is compatible with chef >= 16.0. It might work on older versions but it's not guaranteed.

# Installation
## Chef Supermarket

This cookbook is available in Chef Supermarket -> [direct link](https://supermarket.chef.io/cookbooks/uamsclient) therefore is available for any common chef usage pattern.

## Manual installation/configuration for private/managed Chef server
1. Clone the repository
2. Set required attributes (*attributes/default.rb* / role / environment / use wrapper cookbook)
3. Upload cookbook(s) to the Chef server
```
knife cookbook upload ...
```
4. Add uamsclient::uamsclient recipe (or/and wrapper recipe) to the *run_list*
5. Run chef-client on the node (or wait for scheduled execution)

### Managed locally Agents
Variable `['uamsclient']['uams_managed_locally']` is used to set Agent as managed locally by configuration file. 
Is designed to allow configuration of the UAMS Agent locally, without necessity of adding integrations manually from SWO page.

If the UAMS Agent gets installed as a **managed locally** agent then it will wait for the local configuration file to be accessible. The default local configuration locations are:
- Linux - `/opt/solarwinds/uamsclient/var/local_config.yaml`
- Windows - `C:\ProgramData\SolarWinds\UAMSClient\local_config.yaml`

Chef will automatically copy the file to the needed location. 
The default template of local config file is located at `templates/default/local_config.yaml.erb`.
You can specify a template for each host using paths for each host as described in chef [documentation](https://docs.chef.io/resources/template/#template-specificity).

An additional optional configuration file `credentials_config.yaml` can be used to define credentials providers. This file can be used in conjunction with `local_config.yaml` to retrieve a credential from a defined credential provider.

The default template of credentials configuration file is located at `templates/default/credentials_config.yaml.erb`.

Chef will automatically copy both files (`credentials_config.yaml` and `local_config.yaml`) to the needed location.

You can use chef template syntax to fill the templates with appropriate variables.
To assign values to variables in the template you can fill the attribute file and dictionary `['uamsclient']['local_config']` and `['uamsclient']['credentials_config']` as in the example below.
```
# Template variables for local config
default['uamsclient']['local_config']['mysql_host'] = 'mysql_test'
default['uamsclient']['local_config']['user'] = 'user_test'

# Template variables for credentials config
default['uamsclient']['credentials_config']['aws_access_key_id'] = 'your_access_key_id'
default['uamsclient']['credentials_config']['aws_secret_access_key'] = 'your_secret_access_key'
```
To learn more about building the appropriate local config and credentials config, **check out the official documentation**. You can find information about deploying different plugins, integrations, and supported credential providers.


# Attributes

| Attribute | Description                                                                                  |
| -------------------- |----------------------------------------------------------------------------------------------|
| `node['uamsclient']['uams_access_token'] ` | **required** Access token from SolarWinds Observability                                      |
| `node['uamsclient']['swo_url'] ` | **required** SWO_URL copied from SolarWinds Observability                                    |
| `node['uamsclient']['local_pkg_path']` | **required on windows** Overrides path where installation package is stored temporarily      |
| `node['uamsclient']['uams_metadata']` | Specifies the role for client - in most cases default value is valid one                     |
| `node['uamsclient']['uams_https_proxy'] ` | Specifies HTTPS proxy used by the UAMS Client and its plugins                                |
| `node['uamsclient']['uams_override_hostname'] ` | Optional variable to set a custom Agent name. By default, Agent name is set to the hostname. |
| `node['uamsclient']['remove_installer']` | If installer package should be removed after the installation (default: true)                |
| `node['uamsclient']['uams_managed_locally']` | Variable is used to set Agent as managed locally by configuration file (default: false)      |


Remember that the `uams_https_proxy` attribute sets HTTPS proxy only for the connections established by the UAMS Client and its plugins. To use HTTPS proxy during installation set up HTTPS proxy on your machine so that chef will be able to use it.