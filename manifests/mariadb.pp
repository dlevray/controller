#Classe mariadb
class controller::mariadb {

  if $controller::manage_mariadb {
    File {
      ensure  => 'present',
      group   => '0',
      mode    => '0644',
      owner   => '0',
      backup  => '.puppet-bak',
    }
    file { '/var/tmp/install_db_openstack.sql' :
      content => epp('controller/install_db_openstack.sql.epp'),
      mode    => '0744',
    }

    package { $controller::package_mariadb :
      ensure          => 'present',
      provider        => 'yum',
      install_options => '--disablerepo=centos-openstack-stein', #yum --showduplicates list <package>
      before          => File[$controller::file_mariadb],  #Before (Avant): Applique une ressource avant la ressource cible
      notify          => Exec['config_maria'], #Notify: Applique une ressource avant la ressource cible. La ressource cible est actualisée si la ressource notifiante est modifiée 
    }
      exec { 'config_maria' :
      command     => '/bin/cat /var/tmp/install_db_openstack.sql | /bin/mysql -u root', ##/usr/bin/mysql_secure_installation
      require     => Service[$controller::service_mariadb],
      refreshonly => true,
      #refreshonly: Ne s'applique uniquement que lorsqu'une autre ressource le notifie.
      # onlyif, unless, or creates: Si l'exec a déjà exécuté et reçoit une deuxieme notification, il exécutera sa commande jusqu'à deux fois. 
      #(Si une condition onlyif, unless, or creates, n'est plus remplie après la première exécution, la deuxième exécution ne se produira pas.)  
      }

    file { $controller::file_mariadb :
      content => epp('controller/mariadb.epp'),
      require => Package[$controller::package_mariadb], #require: Applique une ressource après la ressource cible
      notify  => Service[$controller::service_mariadb],
    }

    service { $controller::service_mariadb :
      ensure    => 'running',
      enable    => true,
      subscribe => File[$controller::file_mariadb], #Subscribe: Applique une ressource après la ressource cible. La ressources'actualise si la ressource cible change.
      require   => Package[$controller::package_mariadb],
    }
  }
}
