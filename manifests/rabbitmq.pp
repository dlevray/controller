#Classe RabbitMQ
class controller::rabbitmq {

  if $controller::manage_rabbitmq {
    package { $controller::package_rabbitmq :
      ensure => 'present',
      before => File[$controller::file_rabbitmq],
      notify => Exec['rabbitmq_guest', 'rabbitmq_openstack'],
    }
      Exec {
      require     => Service[$controller::service_rabbitmq],
      refreshonly => true,        
      }
      exec { 'rabbitmq_guest' :
      command     => '/sbin/rabbitmqctl change_password guest PWDGOP',
      }
      exec { 'rabbitmq_openstack' :
      command     => '/sbin/rabbitmqctl add_user openstack PWDGOP',
      }
      #exec { 'rabbitmq_permissions' :
      #command     => 'rabbitmqctl set_permissions openstack ".*" ".*" ".*"',
      #}

    File {
      ensure  => 'present',
      group   => 'rabbitmq',
      mode    => '0644',
      owner   => 'rabbitmq',
      backup  => '.puppet-bak',
    }
    file { $controller::file_rabbitmq :
      content => epp('controller/rabbitmq.config.epp'),
      require => Package[$controller::package_rabbitmq],
      notify  => Service[$controller::service_rabbitmq],
    }

    service { $controller::service_rabbitmq :
      ensure    => 'running',
      enable    => true,
      subscribe => File[$controller::file_rabbitmq],
      require   => Package[$controller::package_rabbitmq],
    }
  }
}
