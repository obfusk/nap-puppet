Exec {
  path => [ '/usr/local/sbin', '/usr/local/bin', '/usr/sbin',
            '/usr/bin', '/sbin', '/bin' ]
}

Package {
  ensure    => installed,
  provider  => 'aptitude'
}

$felix_pkgs = [ 'byobu', 'curl', 'git', 'htop', 'tree', 'vim' ]

package { $felix_pkgs: }

class { 'nap::server':
  # ...
}
