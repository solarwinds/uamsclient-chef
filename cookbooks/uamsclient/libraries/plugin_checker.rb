module PluginChecker
  def self.wait_for_plugin_state(plugin_name, plugin_instance)
    api_url = "http://127.0.0.1:2113/info/plugins?format=json"
    target_state = "STATUS_CODE_OK"
    max_retries = 12
    retry_interval = 5
    retries = 0
    loop do
      begin
        response = Net::HTTP.get(URI(api_url))
        json_data = JSON.parse(response)
        state = json_data.dig(plugin_name, plugin_instance, 'status_code')
        if state == target_state
          Chef::Log.info("Plugin (#{plugin_name}) reached state: #{target_state}")
          break
        else
          Chef::Log.info("Plugin (#{plugin_name}) current state: #{state}")
          raise "Plugin state incorrect"
        end

      rescue StandardError => e
        Chef::Log.error("Error while checking #{plugin_name}: #{e}")
        retries += 1
        if retries >= max_retries
          raise "Maximum status checks for #{plugin_name} reached. Exiting."
        end
        Chef::Log.info("Waiting #{retry_interval} seconds before retrying...")
        sleep retry_interval
      end
    end
  end
end