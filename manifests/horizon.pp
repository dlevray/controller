#Classe NOVA CONTROLLER
class controller::nova inherits controller
{
  package { $controller::package_horizon :
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
  file { $controller::file_horizon :
    content => template('controller/horizon.erb'),
  }
  file { $controller::file_horizon_setting :
    content => template('controller/horizon_setting.erb'),
  }

#if $::operatingsystemmajrelease >= '6' {
# conf_nova_controller = [
#cd /usr/share/openstack-dashboard/
#python manage.py compress
#Rebbot httpd memcached
#]
# exec { $conf_glance : 
#  notify      { "Config GLANCE OK": }  
# }


}
