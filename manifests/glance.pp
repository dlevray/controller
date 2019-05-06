#Classe RabbitMQ
class controller::glance inherits controller
{
  package { $controller::package_glance :
    ensure => 'present',
  }

  File {
    ensure  => 'present',
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
    backup  => '.puppet-bak',
    replace => 'yes'
  }
  file { $controller::file_glance_api :
    content => template('controller/glance-api.erb'),
  }
  file { $controller::file_glance_registry :
    content => template('controller/glance-registry.erb'),
  }

  service { $controller::service_glance :
    ensure => 'running',
    enable => true,
    # requiere = exec $conf_rabbitmq
  }
#if $::operatingsystemmajrelease >= '6' {
# conf_glance = [
#"su -s /bin/sh -c "glance-manage db_sync" glance",
#yum install wget
#wget http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img
#openstack image create "cirros" --file cirros-0.3.5-x86_64-disk.img --disk-format qcow2 --container-format bare --public
#openstack image list
#openstack image show ID
#]
# exec { $conf_glance : 
#  notify      { "Config GLANCE OK": }  
# }


}
