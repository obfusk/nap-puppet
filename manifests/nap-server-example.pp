# --                                                            # {{{1
#
# File        : manifests/nap-server-example.pp
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-03-20
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

# === Defaults ==

Exec {
  path => [ '/usr/local/sbin', '/usr/local/bin', '/usr/sbin',
            '/usr/bin', '/sbin', '/bin' ]
}

Package {
  ensure    => installed,
  provider  => 'aptitude'
}


# === Happy admin ===

$felix_pkgs = [ 'byobu', 'curl', 'git', 'htop', 'tree', 'vim' ]

package { $felix_pkgs: }

exec { 'update-alternatives => editor':
  command => 'update-alternatives --set editor /usr/bin/vim.basic',
  unless  => 'test /etc/alternatives/editor -ef /usr/bin/vim.basic',
}
Package['vim'] -> Exec['update-alternatives => editor']


# === nap server ===

class { 'nap::server':
  # ...
}


# vim: set tw=70 sw=2 sts=2 et fdm=marker :
