# UAMS Client uninstall Cookbook

The **uamsclient uninstall** cookbook is used to uninstall UAMS Client (SolarWinds Observability agent).

# Setup

The **uamsclient uninstall** cookbook is compatible with chef >= 16.0. It might work on older versions but it's not guaranteed.

# Installation
## Chef Supermarket

This cookbook is available in Chef Supermarket -> [direct link](https://supermarket.chef.io/cookbooks/uamsclient) therefore is available for any common chef usage pattern.

## Manual installation/configuration for private/managed Chef server
1. Clone the repository
2. Upload cookbook(s) to the Chef server
```
knife cookbook upload ...
```
3. Add uamsclient::uamsclient_uninstall recipe (or/and wrapper recipe) to the *run_list*
4. Run chef-client on the node (or wait for scheduled execution)