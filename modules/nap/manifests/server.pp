# --                                                            # {{{1
#
# File        : modules/nap/manifests/server.pp
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-03-20
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

class nap::server (
  $base_dir             = '/__nap',
  $libs                 = undef,

  $default_clj_cmd      = undef,
  $default_clj_depcmd   = undef,
  $default_ruby_cmd     = undef,
  $default_ruby_depcmd  = undef,

  $repo = 'https://github.com/obfusk/nap.git',                  # TODO
  $pull                 = true,

  $user                 = 'nap',
  $group                = 'nap',

  # TODO: git_user + gitolite
) {
  # === Configuration ===                                       # {{{1

  $nap_dir              = "$base_dir/nap"
  $nap_apps_dir         = "$base_dir/apps"
  $nap_cfg_dir          = "$base_dir/cfg"
  $nap_log_dir          = "$base_dir/log"

  $dirs                 = [ $nap_dir, $nap_cfg_dir ]
  $dirs_nap             = [ $nap_apps_dir, $nap_log_dir ]

  $napps_file           = "$nap_cfg_dir/napps"
  $napps_puppet         = "$napps_file.puppet.d"

  if ($libs == undef) {
    $nap_libs           = [ "$nap_dir/lib" ]
  } else {
    $nap_libs           = $libs
  }

  $nap_d_clj_cmd        = $default_clj_cmd
  $nap_d_clj_depcmd     = $default_clj_depcmd
  $nap_d_ruby_cmd       = $default_ruby_cmd
  $nap_d_ruby_depcmd    = $default_ruby_depcmd
                                                                # }}}1

  # === Repo ===                                                # {{{1

  obfusk::git::repo { $nap_dir:
    source    => $repo,
    pull      => $pull,
  }

  File[$nap_dir] -> Obfusk::Git::Repo[$nap_dir]
                                                                # }}}1

  # === User + Group ===                                        # {{{1

  user { $user:
    ensure    => present,
    gid       => $group,
    home      => $nap_apps_dir,
    password  => '*',   # disabled (al least on debian/ubuntu)
    shell     => '/bin/bash',
    system    => true,
  }

  group { $group:
    ensure    => present,
    system    => true,
  }
                                                                # }}}1

  # === Init ===                                                # {{{1

  file { '/etc/init.d/nap':
    ensure    => file,
    mode      => 0755,
    source    => 'puppet://modules/nap/server/nap.init',
  }

  exec { 'update-rc.d => nap':
    command   => 'update-rc.d nap defaults'
    unless    => "update-rc.d -n nap defaults | grep 'already exist'",
  }

  Exec['update-rc.d => nap'] -> File['/etc/init.d/nap']
                                                                # }}}1

  # === Sudo ===                                                # {{{1

  file { '/etc/sudoers.d/nap':
    ensure    => file,
    mode      => 0440,
    content   => template('nap/server/nap.sudoers.erb'),
  }
                                                                # }}}1

  # === Files ===                                               # {{{1

  exec { "mkdir -p $base_dir":
    creates   => $base_dir,
  }

  file { $base_dir:
    ensure    => directory,
  }

  File[$base_dir] -> Exec["mkdir -p $base_dir"]


  file { $dirs:
    ensure    => directory,
  }

  file { $dirs_nap:
    ensure    => directory,
    owner     => $user,
    group     => $group,
  }

  file { "$nap_cfg_dir/naprc":
    ensure    => file,
    content   => template('nap/server/naprc.erb'),
  }

  file { $napps_puppet:
    ensure    => directory,
  }

  file { $napps_file:
    ensure    => file,
    content   => template('nap/server/napps.erb'),
  }
                                                                # }}}1

  # ... TODO ...
}

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
