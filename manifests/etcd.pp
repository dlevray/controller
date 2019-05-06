#Classe etcd
class controller::etcd {
  if $controller::manage_etcd {
    package { $controller::package_etcd :
      ensure => 'present',
      before => File[$controller::file_etcd],
    }

    File {
      ensure  => 'present',
      group   => 'root',
      mode    => '0644',
      owner   => 'root',
      backup  => '.puppet-bak',
    }
    file { $controller::file_etcd :
      content => epp('controller/etcd.epp'),
      require => Package[$controller::package_etcd],
      notify  => Service[$controller::service_etcd],
    }

    service { $controller::service_etcd :
      ensure => 'running',
      enable => true,
      subscribe  => File[$controller::file_etcd],
      require    => Package[$controller::package_etcd],
    }
  }
}
