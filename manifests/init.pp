#Classe principale
class controller (

#### init openstack ####
Boolean $manage_install,
Array[String] $package_repo,
Array[String] $package_openstack,
String $file_br_ex,
String $file_br_mgt,

######### Chrony ########
Boolean $manage_chrony,
Array[String] $package_chrony,
String $file_chrony,
String $chrony_server,
String $chrony_allow,
Array[String] $service_chrony,

######### MONGODB ########
Boolean $manage_mongodb,
Array[String] $package_mongodb,
Array[String] $service_mongodb,
String $file_mongodb,

######### MARIADB ########
Boolean $manage_mariadb,
Array[String] $package_mariadb,
Array[String] $service_mariadb,
String $file_mariadb,

######### RABBITMQ ########
Boolean $manage_rabbitmq,
Array[String] $package_rabbitmq,
Array[String] $service_rabbitmq,
String $file_rabbitmq,

######## MEMCACHED #######
Boolean $manage_memcached,
Array[String] $package_memcached,
Array[String] $service_memcached,
String $file_memcached,

######### ETCD ########
Boolean $manage_etcd,
Array[String] $package_etcd,
Array[String] $service_etcd,
String $file_etcd,
String $listen_peer_urls,
String $listen_client_urls,
String $advertise_peer_urls,
String $advertise_client_urls,
String $initial_cluster,

######### KEYSTONE ########
Boolean $manage_keystone,
Array[String] $package_keystone,
Array[String] $service_keystone,
String $file_keystone,
String $file_httpd,
String $file_admin_openrc,
String $file_install_keystone,

######### GLANCE ########
Array[String] $package_glance,
Array[String] $service_glance,
$file_glance_api,
$file_glance_registry,

######### NOVA CONTROLLER ########
Array[String] $package_nova_controller,
Array[String] $service_nova_controller,
$file_nova_controller,
$file_nova_placement,
$nova_controller_myip,

######### HORIZON ########
Array[String] $package_horizon,
$file_horizon,
$file_horizon_setting,
)
{
  contain controller::chrony
  contain controller::install
  contain controller::mongodb
  #contain controller::mariadb
  #contain controller::rabbitmq
  contain controller::memcached
  contain controller::etcd
  contain controller::keystone
  #contain controller::glance
  #contain controller::nova
  #contain controller::horizon
  #contain controller::compute
  #contain controller::neutron
  #contain controller::cinder


#Config Network:
#file { '/etc/sysconfig/network-scripts/ifcfg-ens192'
#file { '/etc/sysconfig/network-scripts/ifcfg-ens224'

#Actions Mariadb:
#/usr/bin/mysql_secure_installation
#/bin/cat /var/tmp/install_db_openstack.sql | /bin/mysql -u root

#Action rabbitmq
#rabbitmqctl change_password guest PWDGOP
#rabbitmqctl add_user openstack PWDGOP
#rabbitmqctl set_permissions openstack ".*" ".*" ".*"

#Action keystone:
#su -s /bin/sh -c "keystone-manage db_sync" keystone
#keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
#keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
#keystone-manage bootstrap --bootstrap-password PWDGOP \
#  --bootstrap-admin-url http://controller:5000/v3/ \
#  --bootstrap-internal-url http://controller:5000/v3/ \
#  --bootstrap-public-url http://controller:5000/v3/ \
#  --bootstrap-region-id RegionOne

# ./root/install_keystone.sh

}

