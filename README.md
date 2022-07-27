# Chef UAMS Client installer

Cookbooks are fundamental working units. Use this cookbook to download and execute the UAMS Client installation script on multiple remote hosts using Chef.

### Directory structure 
<pre>
.
├── README.md
└── cookbooks
    ├── node.json
    ├── solo.rb
    └── uams_client_installator
        ├── attributes
        │   └── default.rb
        └── recipes
            └── default.rb
</pre>

- Parameters for the recipe are located in `attributes/default.rb` 
- All commands for the UAMS Client are located in `recipes/default.rb`

# Chef pre-requirements and execution
## 1. Define parameters for the cookbook
  - Clone the repo and define the parameters in `attributes/default.rb`.
  - Get an Ingestion API token in your SolarWinds Observability. See [API Tokens](https://documentation.solarwinds.com/en/success_center/observability/content/settings/api-tokens.htm))
  - Use `uams-otel-collector-plugin` for `uams_metadata`.

## 2. On each remote machine
  - Install Ruby.
  - Install Chef - Solo.
  - Accept the Chef license: 
  ```chef-client --chef-license accept  > /dev/null```
  - Create the `chef` directory: ``` mkdir /var/chef```

## 3. On a local machine
  - Run the following command from the repo directory: ```rsync -r . root@<machine_IP>:/var/chef```
  - Execute Chef on remote machines: ``ssh root@<machine_IP> "chef-solo -c /var/chef/solo.rb"``
