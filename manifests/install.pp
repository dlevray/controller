#Init Openstack Repos Network
class controller::install {

  if $controller::manage_install {
    package { $controller::package_repo  :
      ensure => 'present',
      notify => Exec['yum_upgrade'], #Notify: Applique une ressource avant la ressource cible. La ressource cible est actualisée si la ressource notifiante est modifiée 
    }
      exec { 'yum_upgrade' :
      command     => '/bin/yum upgrade -y',
      timeout     => '120',
      refreshonly => true #Ne s'applique uniquement que lorsqu'une autre ressource le notifie.
      }

    package { $controller::package_openstack :
      ensure => 'present',
    }

    #service { 'NetworkManager' :
    #  ensure => 'stopped',
    #  enable => false,
    #}

    File {
      ensure  => 'present',
      group   => '0',
      mode    => '0644',
      owner   => '0',
      backup  => '.puppet-bak',
    }
    file { '/etc/hosts' :
      content => epp('controller/host.epp'),
    }
    file { $controller::file_br_mgt :
      content => epp('controller/ifcfg-br-mgt.epp'),
      notify  => Service['network'],
    }
    file { $controller::file_br_ex :
      content => epp('controller/ifcfg-br-ex.epp'),
      notify  => Service['network'],
    }

    service { 'network' :
      ensure     => 'running',
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      subscribe => File[$controller::file_br_mgt, $controller::file_br_ex], 
    }
  }
}
