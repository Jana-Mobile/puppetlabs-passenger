#
class passenger::config {

  case $::osfamily {
    'debian': {
      file { '/etc/apache2/mods-available/passenger.load':
        ensure  => present,
        content => template('passenger/passenger-load.erb'),
        owner   => '0',
        group   => '0',
        mode    => '0644',
        notify  => Service['httpd'],
      }

      file { '/etc/apache2/mods-available/passenger.conf':
        ensure  => present,
        content => template('passenger/passenger-enabled.erb'),
        owner   => '0',
        group   => '0',
        mode    => '0644',
        notify  => Service['httpd'],
      }

      if $passenger::compile_passenger == true {
        $mod_enable_require = [ File['/etc/apache2/mods-available/passenger.load'], Class['passenger::compile'], ]
      } else {
        $mod_enable_require = File['/etc/apache2/mods-available/passenger.load']
      }

      file { '/etc/apache2/mods-enabled/passenger.load':
        ensure  => 'link',
        target  => '/etc/apache2/mods-available/passenger.load',
        owner   => '0',
        group   => '0',
        mode    => '0777',
        require => $mod_enable_require,
        notify  => Service['httpd'],
      }

      file { '/etc/apache2/mods-enabled/passenger.conf':
        ensure  => 'link',
        target  => '/etc/apache2/mods-available/passenger.conf',
        owner   => '0',
        group   => '0',
        mode    => '0777',
        require => File['/etc/apache2/mods-available/passenger.conf'],
        notify  => Service['httpd'],
      }
    }
    'redhat': {

      file { '/etc/httpd/conf.d/passenger.conf':
        ensure  => present,
        content => template('passenger/passenger-conf.erb'),
        owner   => '0',
        group   => '0',
        mode    => '0644',
        notify  => Service['httpd'],
      }
    }
    default:{
      fail("Operating system ${::operatingsystem} is not supported with the Passenger module")
    }
  }

}
