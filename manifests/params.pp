class controller::params
{
  case $::osfamily {
    'RedHat': {
    ############# install openstack
    $package_openstack = ['yum-plugin-priorities', 'centos-release-openstack-rocky', 'python-openstackclient', 'openstack-selinux']

    ######### CHRONY ########
    $package_chrony = 'chrony'
    $file_chrony = '/etc/chrony.conf'
    $service_chrony = 'chronyd'
    $chrony_server = [
      'server 0.centos.pool.ntp.org iburst',
      'server 1.centos.pool.ntp.org iburst',
      'server 2.centos.pool.ntp.org iburst',
      'server 3.centos.pool.ntp.org iburst',
    ]
    #$chrony_allow = '10.0.0.0/24'

    ######### MONGODB ########
    $package_mongodb = 'mongodb-server mongodb'
    $service_mongodb = 'mongod'
    $file_mongodb = '/etc/mongod.conf'

    ######### MARIADB ########
    $package_mariadb = ['mariadb mariadb-server', 'python2-PyMySQL']
    $file_mariadb = '/etc/my.cnf.d/openstack.cnf'
    $service_mariadb = 'mariadb'

    ######### RABBITMQ ########
    $package_rabbitmq = 'rabbitmq-server'
    $file_rabbitmq = '/etc/rabbitmq/rabbitmq.config'
    $service_rabbitmq = 'rabbitmq-server'

    ######### ETCD ########
    $package_etcd = 'etcd'
    $file_etcd = '/etc/etcd/etcd.conf'
    $service_etcd = 'etcd'
    #$ETCD_LISTEN_PEER_URLS = 'http://172.30.43.219:2380'
    #$ETCD_LISTEN_CLIENT_URLS = 'http://172.30.43.219:2379'
    #$ETCD_INITIAL_ADVERTISE_PEER_URLS = 'http://172.30.43.219:2380'
    #$ETCD_ADVERTISE_CLIENT_URLS = 'http://172.30.43.219:2379'
    #$ETCD_INITIAL_CLUSTER = 'controller=http://172.30.43.219:2380'

    ######### KEYSTONE ########
    $package_keystone = ['openstack-keystone', 'httpd', 'mod_wsgi', 'memcached', 'python-memcached']
    $service_keystone = ['etcd', 'httpd', 'memcached']
    $file_memcached = '/etc/sysconfig/memcached'
    $file_keystone = ' /etc/keystone/keystone.conf'
    $file_httpd = '/etc/httpd/conf/httpd.conf'
    $file_admin_openrc = '/root/admin-openrc.erb'
    $file_install_keystone = '/root/install_keystone.sh'

    ######### GLANCE ########
    $package_glance = ['openstack-glance']
    $file_glance_api = '/etc/glance/glance-api.conf'
    $file_glance_registry = '/etc/glance/glance-registry.conf'
    $service_glance = ['openstack-glance-api', 'openstack-glance-registry']

    ######### NOVA CONTROLLER ########
    $package_nova_controller = [
      'openstack-nova-api',
      'openstack-nova-conductor',
      'openstack-nova-console',
      'openstack-nova-novncproxy',
      'openstack-nova-scheduler',
      'openstack-nova-placement-api',
      ]
    $service_nova_controller = [
      'openstack-nova-api',
      'openstack-nova-consoleauth',
      'openstack-nova-scheduler',
      'openstack-nova-conductor',
      'openstack-nova-novncproxy',
    ]
    $file_nova_controller = '/etc/nova/nova.conf'
    $file_nova_placement = '/etc/httpd/conf.d/00-nova-placement-api.conf'
    $nova_controller_myip = '10.0.0.100'

    ######### HORIZON ########
    $package_horizon = 'openstack-dashboard'
    $file_horizon = '/etc/httpd/conf.d/openstack-dashboard.conf'
    $file_horizon_setting = '/etc/openstack-dashboard/local_settings'
    }
    default : {
    }
  }
}
