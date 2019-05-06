#Classe NOVA CONTROLLER
class controller::nova inherits controller
{
  package { $controller::package_nova_controller :
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
  file { $controller::file_nova_controller :
    content => template('controller/glance-api.erb'),
  }
  file { $controller::file_nova_placement :
    content => template('controller/nova-placement-api.erb'),
  }

  service { $controller::service_nova_controller :
    ensure => 'running',
    enable => true,
    # requiere = exec $conf_rabbitmq
  }

#if $::operatingsystemmajrelease >= '6' {
# conf_nova_controller = [
#"systemctl restart httpd",
#"su -s /bin/sh -c "nova-manage api_db sync" nova"
#"su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova"
#"su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova 109e1d4b-536a-40d0-83c6-5f121b82b650"
#"su -s /bin/sh -c "nova-manage db sync" nova"
#"nova-manage cell_v2 list_cells"
#]
# exec { $conf_glance : 
#  notify      { "Config GLANCE OK": }  
# }


}
