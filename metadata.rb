name                    'kube-hops'
maintainer              'Logical Clocks AB'
maintainer_email        'fabio@logicalclocks.com'
license                 ''
description             'Installs/Configures kube-hops-chef'
version                 '1.0.0'

depends 'kagent'
depends 'ndb'
depends 'sysctl'
depends 'resolver'
depends 'kernel_module'

recipe 'kube-hops::ca', 'Create and configure Kubernetes\'s CA'
recipe 'kube-hops::master', 'Configure a node as Kubernetes master'
recipe 'kube-hops::node', 'Configure a node as Kubernetes slave'
recipe 'kube-hops::addons', 'Deploy addons on the cluster'
recipe 'kube-hops::hopsworks', 'Configure Hopsworks to use Kubernetes'


attribute "kube-hops/cgroup-driver",
          :description =>  "Cgroup driver",
          :type => 'string'

attribute "kube-hops/kubernetes_version",
          :description =>  "kubernetes_version",
          :type => 'string'

attribute "kube-hops/image_repo",
          :description =>  "Repo for default images",
          :type => 'string'

attribute "kube-hops/cidr",
          :description =>  "Cluster address space",
          :type => 'string'

attribute "kube-hops/dns_ip",
          :description =>  "Ip of the DNS service",
          :type => 'string'

attribute "kube-hops/fallback_dns",
          :description =>  "IP of the fallback DNS server for non-cluster resolution",
          :type => 'string'

attribute "kube-hops/flannel/iface-regex",
          :description =>  "iface-regex to configure flannel daemonset",
          :type => 'string'

attribute "kube-hops/apiserver/port",
          :description =>  "Port on which the apiserver listens for requests",
          :type => 'string'

attribute "kube-hops/master/untaint",
          :description =>  "Untaint master - meaning that user pods can run on the master node",
          :type => 'string'

attribute "kube-hops/conf_dir",
          :description =>  "Kubernetes configuration dir",
          :type => 'string'

attribute "kube-hops/kubelet_dir",
          :description =>  "Kubelet configuration dir",
          :type => 'string'

attribute "kube-hops/pki/ca_api",
          :description =>  "endpoint of the CA api server (Hopsworks)",
          :type => 'string'

attribute "kube-hops/pki/ca_api_user",
          :description =>  "User running the CA api server",
          :type => 'string'

attribute "kube-hops/pki/ca_api_group",
          :description =>  "Group running the CA api server",
          :type => 'string'

attribute "kube-hops/pki/ca_keypw",
          :description =>  "Password for the kube-ca key",
          :type => 'string'

attribute "kube-hops/pki/rootca_keypw",
          :description =>  "Password for the root-ca key",
          :type => 'string'

attribute "kube-hops/pki/rootca_keypw",
          :description =>  "Password for the root-ca key",
          :type => 'string'

attribute "kube-hops/pki/dir",
          :description =>  "PKI artifacts directory on master and node machines",
          :type => 'string'

attribute "kube-hops/pki/keysize",
          :description =>  "length of keys",
          :type => 'string'

attribute "kube-hops/pki/days",
          :description =>  "Expiration time for certificates",
          :type => 'string'

attribute "kube-hops/pki/verify_hopsworks_cert",
          :description =>  "Verify Hopsworks HTTPS certificate",
          :type => 'string'

attribute "kube-hops/pki/hopsworks_cert_pwd",
          :description =>  "Password for the Hopsworks certificate",
          :type => 'string'

attribute "kube-hops/docker_dir",
          :description =>  "Path on the host machine to be used to store docker containers,imgs,logs",
          :type => 'string'

attribute "kube-hops/docker_img",
          :description =>  "Comma separated list of images to load in the docker registry",
          :type => 'string'

attribute "kube-hops/docker_img_tar_url",
          :description =>  "Remote location of the tar with the images to laod",
          :type => 'string'

attribute "kube-hops/docker_img_reg_url",
          :description =>  "Remote container images registry from which to fetch the images",
          :type => 'string'

attribute "kube-hops/registry",
          :description =>  "Service name for the internal registry deployed in kubernetes",
          :type => 'string'

attribute "kube-hops/pull_policy",
          :description =>  "Image pull policy for new containers",
          :type => 'string'
