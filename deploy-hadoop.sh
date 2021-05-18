#!/bin/bash 
set -e
# Any subsequent(*) commands which fail will cause the shell script to exit immediately

#U can get the script by doing
# wget --no-check-certificate --no-cache --no-cookies https://github.com/thalerion/thalerion/raw/master/deploy-hadoop.sh?commit=d554791 -O deploy-bigtop.sh
# chmod +x deploy-bigtop.sh

# Welcome
RED='\033[0;31m'; BLUE='\033[0;34m'; DEFAULTC='\033[0m'
printf "\nWelcome to the ${RED}Bigtop${DEFAULTC} installer\n\n"
 
 
# Check for CentOS 6
rel=$(cat /etc/redhat-release 2> /dev/null)
if [[ -n "$rel" && ${rel:15:1}==8 ]]; then
        printf "This OS is running ${BLUE}$rel${DEFAULTC} which is compatible with this helper script.\n\n"
else
        printf "This OS is ${RED}not compatible${DEFAULTC} with this Bigtop release. Please install CentOS 8.x\n\n"
        exit 1
fi
 
 
# Get hostname
printf "Enter the hostname of the master node or press Enter to use ${RED}$(hostname -f)${DEFAULTC} : "
read mnode
mnode=${mnode:-$(hostname -f)}
echo
 
 
# Install Dependencies
if rpm -q --quiet git
then 
  echo "git installed" 
else
sudo yum -y install git
fi


 
 
# Install Puppet
if rpm -q --quiet puppet
then 
  echo "puppet installed" 
else
sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
sudo yum -y install puppet
sudo puppet module install puppetlabs-stdlib
fi
 
# Install Bigtop Puppet
if [ -d "/bigtop-home" ] 
then
    echo "Directory /path/to/dir exists." 
else
    echo "Error: Directory /path/to/dir does not exists."    
    sudo git clone https://github.com/apache/bigtop.git /bigtop-home
    sudo sh -c "cd /bigtop-home; git checkout release-1.5.0"
    sudo cp -r /bigtop-home/bigtop-deploy/puppet/hieradata/ /etc/puppetlabs/puppet/    
    sudo su root -c "cat > /etc/puppetlabs/puppet/hiera.yaml << EOF
---
:yaml:
  :datadir: /etc/puppetlabs/puppet/hieradata
:hierarchy:
  - site
  - "bigtop/%{hadoop_hiera_ha_path}"
  - bigtop/cluster
  - bigtop/repo
EOF
"    
fi

 
# Configure
sudo su root -c "cat > /etc/puppetlabs/puppet/hieradata/site.yaml << EOF
---
bigtop::hadoop_head_node: "$mnode"
hadoop::hadoop_storage_dirs:
- /data/1
- /data/2

bigtop::roles_enabled: true

bigtop::roles:
- namenode
- resourcemanager
- datanode
- nodemanager
- hadoop-client
- mapred-app
- oozie-server
- oozie-client
- spark-on-yarn
- spark-yarn-slave


bigtop::jdk_package_name: "java-1.8.0-openjdk-devel.x86_64"
bigtop::bigtop_repo_uri: "http://repos.bigtop.apache.org/releases/1.5.0/centos/8/x86_64"
EOF
"
 
 
# Deploy
sudo puppet apply --modulepath=/bigtop-home/bigtop-deploy/puppet/modules:/etc/puppetlabs/code/modules /bigtop-home/bigtop-deploy/puppet/manifests
