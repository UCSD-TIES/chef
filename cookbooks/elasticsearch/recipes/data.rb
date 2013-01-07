node.elasticsearch[:data][:devices].each do |device, params|
  # Format volume if format command is provided and volume is unformatted
  #
  bash "Format device: #{device}" do
    __command  = "#{params[:format_command]} #{device}"
    __fs_check = params[:fs_check_command] || 'dumpe2fs'

    code __command

    only_if { params[:format_command] }
    not_if  "#{__fs_check} #{device}"
  end

  # Create directory with proper permissions
  #
  directory params[:mount_path] do
    owner node.elasticsearch[:user] and group node.elasticsearch[:user] and mode 0775
    recursive true
  end

  # Mount device to elasticsearch data path
  #
  mount params[:mount_path] do
    device  device
    fstype  params[:file_system]
    options params[:mount_options]
    action  [:mount, :enable]

    only_if { File.exists?(device) }
    if node.elasticsearch[:data_path].include?(params[:mount_path])
      Chef::Log.debug "Schedule Elasticsearch service restart..."
      notifies :restart, resources(:service => 'elasticsearch')
    end
  end

  # Ensure proper permissions
  #
  directory params[:mount_path] do
    owner node.elasticsearch[:user] and group node.elasticsearch[:user] and mode 0775
    recursive true
  end
end
