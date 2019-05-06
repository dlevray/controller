 class controller::neutron inherits controller
{


file { '/etc/sysconfig/network-scripts/ifcfg-eth2' :
  ensure  => 'present',
  group   => '0',
  mode    => '0664',
  owner   => '0',
  backup  => '.puppet-bak',
  replace => 'yes'
  content => template('system/ifcfg-eth2.erb');
}


}

