# Installation chrony
class controller::chrony {
# voir l'outil 'timedatectl RHL7
#chronyc sources -v
#tzselect :  identifiez le fuseau horaire

  if $controller::manage_chrony {
    package { $controller::package_chrony :
      ensure => 'present',
      before => File[$controller::file_chrony],
    }

    file { $controller::file_chrony :
      ensure  => 'present',
      group   => '0',
      mode    => '0644',
      owner   => '0',
      backup  => '.puppet-bak',
      content => epp('controller/chrony.epp'),
      require => Package[$controller::package_chrony],
      notify  => Service[$controller::service_chrony],
    }

    service { $controller::service_chrony :
      ensure     => 'running',
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      subscribe  => File[$controller::file_chrony],
      require    => Package[$controller::package_chrony],
    }
  }
}
