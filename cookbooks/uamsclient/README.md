# UAMS Client Cookbook

The **uamsclient** cookbook is used to deploy and configure UAMS Client (SolarWinds Observability agent).

# Setup

The **uamsclient** cookbook is compatible with chef >= 16.0. It might work on older versions but it's not guaranteed.

# Installation

1. Clone the repository
2. Set required attributes (*attributes/default.rb* / role / environment / use wrapper cookbook)
3. Upload cookbook(s) to the Chef server
```
knife cookbook upload ...
```
4. Add uamsclient::uamsclient recipe to the *run_list*
5. Run chef-client on the node (or wait for scheduled execution)

# Attributes

| Attribute | Description |
| -------------------- | --------------------------------------------------------------- |
| `node['uamsclient']['uams_access_token'] ` | **required** Access token from SolarWinds Observability |
| `node['uamsclient']['local_pkg_path']` | **required on windows** Overrides path where installation package is stored temporarily |
| `node['uamsclient']['uams_metadata']` | Specifies the role for client - in most cases default value is valid one |
| `node['uamsclient']['remove_installer']` | If installer package should be removed after the installation (default: true) |
