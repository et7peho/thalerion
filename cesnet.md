Ta hem cesnet-site
puppet module install cesnet-site_hadoop --version 4.0.1

skapa en node.pp med följande innehåll.

node default {
class{"hadoop":
  hdfs_hostname => $::fqdn,
  yarn_hostname => $::fqdn,
  slaves => [ $::fqdn ],
  frontends => [ $::fqdn ],
  properties => {
    'dfs.replication' => 1,
  }
}

node default {
  # HDFS
  include hadoop::namenode
  # YARN
  include hadoop::resourcemanager
  # MAPRED
  include hadoop::historyserver
  # slave (HDFS)
  include hadoop::datanode
  # slave (YARN)
  include hadoop::nodemanager
  # client
  include hadoop::frontend
}
}
sedan puppet apply  node.pp
Kan behövas en --modulepath parameter
