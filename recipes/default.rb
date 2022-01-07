# For Flannel (overlay network) to work we need to pass bridged IPv4 traffic to iptables’ chains
if node['platform_family'].eql?('rhel')
  # For centos, at least on a VM we need to load some kernel modules
  kernel_module 'bridge' do
    action :install
  end

  kernel_module 'br_netfilter' do
    action :install
  end
end

sysctl_param 'net.bridge.bridge-nf-call-iptables' do
  value 1
end

# Start the docker deamon
service 'docker' do
  action [:enable, :start]
end

# Install g++ to be able to install http-cookie gem
case node['platform_family']
when 'rhel'
  package 'gcc-c++'
when 'debian'
  package 'g++'
end

# If AirGapped installation, download control plane images from download_url and load them 
if node['kube-hops']['image_repo'].eql?("")
  control_plane_images = "#{Chef::Config['file_cache_path']}/#{::File.basename(node['kube-hops']['control_plane_imgs_url'])}"
  remote_file control_plane_images do
    source node['kube-hops']['control_plane_imgs_url']
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  bash 'load_control_plane_imgs' do
    user 'root'
    group 'root'
    code <<-EOH
      docker load < #{control_plane_images}
    EOH
    action :run
  end
end

if node['kube-hops']['kfserving']['enabled'].casecmp?("true")
  # Load kfserving images
  # This is done in the default recipe so that both the master 
  # and node recipe pull the necessary docker images
  kfserving_images = "#{Chef::Config['file_cache_path']}/kfserving-v#{node['kube-hops']['kfserving']['version']}.tgz"
  remote_file kfserving_images do
    source node['kube-hops']['kfserving']['img_tar_url']
    owner node['kube-hops']['user']
    group node['kube-hops']['group']
    mode "0644"
  end
  
  bash "load" do
    user 'root'
    group 'root'
    code <<-EOH
      docker load < #{kfserving_images}
    EOH
  end
end

# Load nvidia device plugin image to registry for airgapped installations
if node['kube-hops']['device'].eql?("nvidia")
  nvidia_device_plugin_image = "#{Chef::Config['file_cache_path']}/nvidia_device_plugin#{node['kube-hops']['k8s_device_plugin']['tar']}"
  remote_file nvidia_device_plugin_image do
    source node['kube-hops']['k8s_device_plugin']['img_tar_url']
    owner node['kube-hops']['user']
    group node['kube-hops']['group']
    mode "0644"
  end

  bash "load" do
    user 'root'
    group 'root'
    code <<-EOH
      docker load < #{nvidia_device_plugin_image}
    EOH
  end
end

# Install gem as helper to send Hopsworks requrests to sign certificates
chef_gem 'http-cookie'

hopsworks_ip = private_recipe_ip('hopsworks', 'default')
hopsworks_https_port = 8181
if node.attribute?('hopsworks')
  if node['hopsworks'].attribute?('https') and node['hopsworks']['https'].attribute?('port')
    hopsworks_https_port = node['hopsworks']['https']['port']
  end
end

node.override['kube-hops']['pki']['ca_api'] = "#{hopsworks_ip}:#{hopsworks_https_port}"
