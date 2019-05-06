 class controller::exec inherits controller
{

  if $::kernelrelease != '2.6.18-406.el5' and $::kernelrelease != '2.6.32-573.3.1.el6.x86_64' {

        'rhnreg_ks --activationkey=1-keypmurhel6.6-P2-2015 --serverUrl=https://satellite-a.adm.parimutuel.local/XMLRPC --force',
        'rhnreg_ks --activationkey=1-keypmurhel5.11-P2-2015 --serverUrl=https://satellite-a.adm.parimutuel.local/XMLRPC --force',
        'rhn-profile-sync',
        'yum check-update',
        'yum update -y --skip-broken --exclude=tibco*,jboss*,TIVsm*,imp*,jre*,jdk*,rabbit*,openldap*,weblo*,java*,expect*,tcl*',
        #"yum repolist",

        Exec {
          path            => '/bin:/usr/bin/:/usr/sbin:/usr/local/bin',
          cwd             => '/var/tmp',
          logoutput       => 'on_failure',
          timeout         => '1000',
          tries           => '3',
          try_sleep       => '120',
          user            => 'root',
        }


        yum_clean = [
        'yum remove -y puppetlabs-release.noarch',
        'yum clean all',
        'yum clean metadata',
        ]
        exec { $yum_clean :
          notify      { "Appel pt22015 avec ${name}": }
        }

   }


                  }
                if $::operatingsystemmajrelease >= '6' {


                elsif $::operatingsystemmajrelease < '6'  {


                     # serveurs utilisant le SAN HDS
                     if $::virtual == 'physical' {
                            exec {'/opt/DynamicLinkManager/bin/dlmupdatesysinit':
                            user      =>  root,
                            onlyif    =>  'test -f /opt/DynamicLinkManager/bin/dlmupdatesysinit',
                            path      =>  ['/usr/bin','/usr/sbin','/bin','/sbin'],
                            timeout   =>  '300',
                            tries     =>  '3',
                            try_sleep =>  '5',
                            notify    =>  Notify['Execution du script SAN HDS effectue'],
                            user      => 'root'
                            }


                            #if defined(Package['oracleasmlib']) {
                            #    package { 'oracleasmlib':
                            #    ensure => installed,
                             #   }
                            #Si paquet oracleasmlib en version 2.0.4-1.el5
                            #$oracle =[
                            #"yum update oracleasmlib -y --nogpgcheck",
                            #"yum install -y oracleasm-2.6.18-404.el5",
                             # physique arret service oracle 'execution script'
                             #]
                             #exec {  $oracle :
                             #cwd     =>    "/var/tmp",
                             #path   =>     ["/usr/sbin/","/usr/bin/","/sbin/"],
                             #timeout =>    "300",
                             #tries =>      "3",
                             #try_sleep =>  "5",
                             #}
                     }


                        if $::uptime_hours > '30' {
                                exec {  'shutdown -r now' :
                                        cwd       =>      '/var/tmp',
                                        path      =>      ['/usr/sbin/','/usr/bin/','/sbin/'],
                                        timeout   =>      '300',
                                        tries     =>      '3',
                                        try_sleep =>      '5',
                                }
                        }


        }
        else { notify {'version kernel deja a jour':} }
}
