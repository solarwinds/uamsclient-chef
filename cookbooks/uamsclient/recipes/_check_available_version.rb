remote_file 'Download temporary file with available package metadata' do
  path Chef::Config['file_cache_path'] + '/' + 'metadata.yml'
  source lazy { node['uamsclient']['install_pkg_url'] + '/' + 'metadata.yml' }
  action :create
end

ruby_block 'Get available version from metadata file' do
  block do
    node.run_state['available_version'] = ''
    File.foreach(Chef::Config['file_cache_path'] + '/' + 'metadata.yml') do |line|
      if line.start_with?('version:')
        node.run_state['available_version'] = (line.chomp.split)[1]
        break
      end
    end
  end
  action :run
end
