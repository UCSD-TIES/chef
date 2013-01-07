module Extensions

  # Creates an EBS volume based on passed parameters and attaches it to the instance
  # via the [Fog](http://rubydoc.info/gems/fog/Fog/Compute/AWS/Volume).
  #
  # The credentials for accessing AWS API are loaded from `node.elasticsearch[:cloud]`,
  # you need to provide volume properties such as _size_ in the `params[:ebs]` hash.
  #
  def create_ebs device, params={}

    # Install the Fog gem for Chef
    chef_gem("fog") { action :install }

    ruby_block "Create EBS volume on #{device} (size: #{params[:ebs][:size]}GB)" do

      block do
        require 'fog'
        require 'open-uri'

        region      = params[:region] || node.elasticsearch[:cloud][:aws][:region]
        instance_id = open('http://169.254.169.254/latest/meta-data/instance-id'){|f| f.gets}
        raise "[!] Cannot get instance id from AWS meta-data API" unless instance_id

        Chef::Log.debug("Region: #{region}, instance ID: #{instance_id}")

        aws = Fog::Compute.new :provider =>              'AWS',
                               :region   =>              region,
                               :aws_access_key_id =>     node.elasticsearch[:cloud][:aws][:access_key],
                               :aws_secret_access_key => node.elasticsearch[:cloud][:aws][:secret_key]


        server = aws.servers.get instance_id

        # Create EBS volume if the device is free
        unless server.volumes.map(&:device).include?(device)
          options = { :device                => device,
                      :size                  => params[:ebs][:size],
                      :delete_on_termination => params[:ebs][:delete_on_termination],
                      :availability_zone     => server.availability_zone,
                      :server                => server }

          options[:type] = params[:ebs][:type] if params[:ebs][:type]
          options[:iops] = params[:ebs][:iops] if params[:ebs][:iops] and params[:ebs][:type] == "io1"

          if params[:ebs][:snapshot_id]
            if snapshot = aws.snapshots.get(params[:ebs][:snapshot_id])
              Chef::Log.info "Creating EBS from snapshot: #{snapshot.id} (" +
                             "Tags: #{snapshot.tags.inspect}, "             +
                             "Description: #{snapshot.description})"
              options[:snapshot_id] = snapshot.id
            else
              __message = "[!] Cannot find snapshot: #{params[:ebs][:snapshot_id]}"
              Chef::Log.fatal __message
              raise __message
            end
          end

          volume = aws.volumes.new options
          volume.save

          # Create tags
          aws.tags.new(:key => "Name", :value => node.name, :resource_id => volume.id, :resource_type => "volume").save
          aws.tags.new(:key => "ClusterName", :value => node.elasticsearch[:cluster_name], :resource_id => volume.id, :resource_type => "volume").save

          # Checking if block device is attached
          Chef::Log.info("Attaching volume: #{volume.id} ")
          loop do
            `ls #{device} > /dev/null 2>&1`
            break if $?.success?
            print '.'
            sleep 1
          end

          Chef::Log.debug("Volume #{volume.id} is attached to #{instance_id} on #{device}")
        end

      end

    end

  end

end
