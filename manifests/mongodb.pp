#Claas mongodb
class controller::mongodb {

  if $controller::manage_mongodb {
    package { $controller::package_mongodb :
      ensure => 'present',
      before => File[$controller::file_mongodb],
    }

    file { $controller::file_mongodb :
      ensure  => 'present',
      group   => '0',
      mode    => '0644',
      owner   => '0',
      backup  => '.puppet-bak',
      content => epp('controller/mongodb.epp'),
      require => Package[$controller::package_mongodb],
      notify  => Service[$controller::service_mongodb], 
    }

    service { $controller::service_mongodb:
      ensure => 'running',
      enable => true,
      subscribe => File[$controller::file_mongodb],
      require   => Package[$controller::package_mongodb],
    }
  }
}
