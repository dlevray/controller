#Classe keystone
class controller::keystone {
  if $controller::manage_keystone {
    package { $controller::package_keystone :
      ensure => 'present',
      before => File[$controller::file_keystone],
    }

    File {
      ensure  => 'present',
      group   => 'root',
      mode    => '0644',
      owner   => 'root',
      backup  => '.puppet-bak',
    }
    file { $controller::file_keystone :
      content => epp('controller/keystone.epp'),
      require => Package[$controller::package_keystone],
      #notify  => Service[$controller::service_keystone],
    }
    file { $controller::file_httpd :
      content => epp('controller/httpd.epp'),
      require => Package[$controller::package_keystone],
      #notify  => Service[$controller::service_keystone],
      #Verifier les droits et proprietaire du fichier
    }

    #ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/

    file { $controller::file_admin_openrc :
      content => epp('controller/admin-openrc.epp'),
    }
    file { $controller::file_install_keystone :
      content => epp('controller/install_keystone.epp'),
      mode    => '0744',
    }


    service { $controller::service_keystone :
      ensure => 'running',
      enable => true,
      #subscribe  => File[$controller::file_keystone],
      require    => Package[$controller::package_keystone],
    }
  }
}
