 class controller::cinder inherits controller
# sous RHL7 l'outil 'partprobe' permet de déclarer les new partitions apres fdisk/gdisk
{
  
  
	# Define: Physical volume
	define volume (
	  $ensure,
	  $pv,
	  $vg,
	  $fstype  = undef,
	  $size    = undef,
	  $extents = undef,
	  $initial_size = undef
	  ) 
	
  {	
   
  if ($name == undef) { fail("volume \$name can't be undefined") }
  else {
    
  
      #Case ensure: Clean, abs, present
      case $ensure {
    
			           # Clean up the whole chain.
						    'cleaned': {
								      # This may only need to exist once
								      if ! defined(Physical_volume[$pv]) {
								        physical_volume { $pv: ensure => present }
								      }
								      
								      # This may only need to exist once
								      if ! defined(Volume_group[$vg]) {
										      volume_group { $vg:
										          ensure           => present,
										          physical_volumes => $pv,
										          before           => Physical_volume[$pv]
										      }
										
										      logical_volume { $name:
										          ensure       => present,
										          volume_group => $vg,
										          size         => $size,
										          initial_size => $initial_size,
										          before       => Volume_group[$vg]
										      }
								      }
						    }
    
    
    
						    # Just clean up the logical volume
						    'absent': {
								      logical_volume { $name:
								        ensure       => absent,
								        volume_group => $vg,
								        size         => $size
								      }
						    }
    
    
    
						    # Create the whole chain.
						    'present': {
								      # This may only need to exist once
								      ensure_resource('physical_volume', $pv, { 'ensure' => $ensure })
								
								      # This may only need to exist once
								      if ! defined(Volume_group[$vg]) {
								        volume_group { $vg:
								          ensure           => present,
								          physical_volumes => $pv,
								          require          => Physical_volume[$pv]
								        }
								      }
								
								      logical_volume { $name:
								        ensure       => present,
								        volume_group => $vg,
								        size         => $size,
								        extents      => $extents,
								        require      => Volume_group[$vg]
								      }
								
								      if $fstype != undef {
								        filesystem { "/dev/${vg}/${name}":
								          ensure  => present,
								          fs_type => $fstype,
								          require => Logical_volume[$name]
								        }
								      }
						    }
    
    
						    default: {
						      fail ( 'puppet-volume: ensure parameter can only be set to cleaned, absent or present' )
						    }
						    
			} # Fin case ensure			
			
		} # Fin else
		
  } # Fin fonction 

} # Fin module 



  
# Define: logical_volume
define logical_volume (
  $volume_group,
  $size              = undef,
  $initial_size      = undef,
  $ensure            = present,
  $options           = 'defaults',
  $pass              = '2',
  $dump              = '1',
  $fs_type           = 'ext4',
  $mkfs_options      = undef,
  $mountpath         = "/${name}",
  $mountpath_require = false,
  $createfs          = true,
  $extents           = undef,
  $stripes           = undef,
  $stripesize        = undef,
  $readahead         = undef,
  $range             = undef,
) {

  validate_bool($mountpath_require)

  if ($name == undef) {
    fail("logical_volume \$name can't be undefined")
  }

  if $mountpath_require {
    Mount {
      require => File[$mountpath],
    }
  }

  $mount_ensure = $ensure ? {
    'absent' => absent,
    default  => mounted,
  }

  if $ensure == 'present' and $createfs {
    Logical_volume[$name] ->
    Filesystem["/dev/${volume_group}/${name}"] ->
    Mount[$mountpath]
  } elsif $ensure != 'present' and $createfs {
    Mount[$mountpath] ->
    Filesystem["/dev/${volume_group}/${name}"] ->
    Logical_volume[$name]
  }

  logical_volume { $name:
    ensure       => $ensure,
    volume_group => $volume_group,
    size         => $size,
    initial_size => $initial_size,
    stripes      => $stripes,
    stripesize   => $stripesize,
    readahead    => $readahead,
    extents      => $extents,
    range        => $range,
  }

  if $createfs {
    filesystem { "/dev/${volume_group}/${name}":
      ensure  => $ensure,
      fs_type => $fs_type,
      options => $mkfs_options,
    }
  }

  if $createfs or $ensure != 'present' {
    exec { "ensure mountpoint '${mountpath}' exists":
      path    => [ '/bin', '/usr/bin' ],
      command => "mkdir -p ${mountpath}",
      unless  => "test -d ${mountpath}",
    } ->
    mount { $mountpath:
      ensure  => $mount_ensure,
      device  => "/dev/${volume_group}/${name}",
      fstype  => $fs_type,
      options => $options,
      pass    => $pass,
      dump    => $dump,
      atboot  => true,
    }
  }
}




# Define: volume_group
define volume_group (
  $physical_volumes,
  $ensure           = present,
  $logical_volumes  = {},
) {

  validate_hash($logical_volumes)

  if ($name == undef) {
    fail("volume_group \$name can't be undefined")
  }

  physical_volume { $physical_volumes:
    ensure => $ensure,
  } ->

  volume_group { $name:
    ensure           => $ensure,
    physical_volumes => $physical_volumes,
  }

  create_resources(
    'logical_volume',
    $logical_volumes,
    {
      ensure       => $ensure,
      volume_group => $name,
    }
  )
}
  
  

$volume_groups = {},
validate_hash($volume_groups)
create_resources('volume_group', $volume_groups)

  
# Cette fonction (create_resources) prend deux arguments obligatoires: un type de ressource, et une table de hachage décrit un ensemble de ressources. 
# Le hachage doit être sous la forme {title => {paramètres}}:
#$myusers = {
#  'nick' => { uid    => '1330',
#              gid    => allstaff,
#              groups => ['developers', 'operations', 'release'], },
#  'dan'  => { uid    => '1308',
#              gid    => allstaff,
#              groups => ['developers', 'prosvc', 'release'], },
#}

create_resources(user, $myusers)

Un troisième, paramètre optionnel peut être donnée, aussi comme un hachage:

$defaults = {
  'ensure'   => present,
  'provider' => 'ldap',
}

create_resources(user, $myusers, $defaults)

Les valeurs figurant sur le troisième argument sont ajoutés aux paramètres de chaque ressource présente dans l ensemble donné sur le second argument. 
Si un paramètre est présent sur les deux les deuxième et troisième arguments, l un sur le deuxième argument l emporte.

# $int_hash=hiera('network::intefaces_hash')  création d'une variable 
# $ip_eth0=$int_hash['eth0']['ipadress']  permet de  se référer à des valeurs uniques à l'intérieur de sa structure 
# ipadress <%= @int_hash['eth0']['ipadress'] %> accéder à cette valeur à partir d'un modèle, écrire directement dans le fichier erb:

#L'utilisation de Hiera avec les tables hachage peut être très puissante. 
#Par exemple, nous pouvons les utiliser à l'intérieur des manifeste Puppet avec la fonction de "create_resources", 
#avec le hachage des données des utilisateurs et une seule ligne de code comme suit:
#create_ressources(user, hiera_hash($user))
 
# network::interfaces_hash:    
#  eth0: 
#    ipadress: 10.0.0.1
#    netmask: 255.255.255.0
#    network: 10.0.0.0
#    gataway:  10.0.0.1
#    post_up:
#   
#  eth2: 
#    enable_dhcp: true
#  eth3: 
#    auto: false
#    method: manual
#  eth4: 
#    auto: false
#    method: manual
 


# Un hachage complexe est généralement utilisé avec une fonction create_resources:
# create_resources('network::interface',$intefaces_hash)
# ici, network::interface est censé accepter comme argument une table de hachage pour configurer une ou plusieurs interfaces réseau.

  
}
