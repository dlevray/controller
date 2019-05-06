#Classe memcached
class controller::memcached {

  if $controller::manage_memcached {
    package { $controller::package_memcached :
      ensure => 'present',
      before => File[$controller::file_memcached],
    }

    File {
      ensure  => 'present',
      group   => '0',
      mode    => '0644',
      owner   => '0',
      backup  => '.puppet-bak',
    }
    file { $controller::file_memcached :
      content => epp('controller/memcached.epp'),
      require => Package[$controller::package_memcached],
      notify  => Service[$controller::service_memcached],
    }

    service { $controller::service_memcached:
      ensure => 'running',
      enable => true,
      subscribe  => File[$controller::file_memcached],
      require    => Package[$controller::package_memcached],
    }
  }
}
