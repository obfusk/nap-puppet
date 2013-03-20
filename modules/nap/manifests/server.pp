class nap::server (
  $base_dir             = '/__nap',
  $libs                 = undef,

  $default_clj_cmd      = undef,
  $default_clj_depcmd   = undef,
  $default_ruby_cmd     = undef,
  $default_ruby_depcmd  = undef,

  $repo = 'https://github.com/noxqsgit/nap.git',                # TODO
  $pull                 = true,

  $user                 = 'nap',
  $group                = 'nap',
) {
  # === Configuration ===

  $nap_dir              = "$base_dir/nap"
  $nap_apps_dir         = "$base_dir/apps"
  $nap_cfg_dir          = "$base_dir/cfg"
  $nap_log_dir          = "$base_dir/log"

  $dirs                 = [ $nap_dir, $nap_cfg_dir ]
  $dirs_nap             = [ $nap_apps_dir, $nap_log_dir ]

  $napps_file           = "$nap_cfg_dir/napps"
  $napps_puppet         = "$napps_file-puppet.d"

  if ($libs == undef) {
    $nap_libs             = [ "$nap_dir/lib" ]
  } else {
    $nap_libs             = $libs
  }

  $nap_d_clj_cmd          = $default_clj_cmd
  $nap_d_clj_depcmd       = $default_clj_depcmd
  $nap_d_ruby_cmd         = $default_ruby_cmd
  $nap_d_ruby_depcmd      = $default_ruby_depcmd


  # === Repo ===

  obfusk::git::repo { $nap_dir:
    source  => $repo,
    pull    => $pull,
  }
  File[$nap_dir] -> Obfusk::Git::Repo[$nap_dir]


  # === User ===

  user { $user:
    ensure    => present,
    gid       => $group,
    home      => $nap_apps_dir,
    password  => '*', # disabled                                # TODO
    system    => true,
  }


  # === Files ===

  file { $dirs:
    ensure => directory,
  }

  file { $dirs_nap:
    ensure  => directory,
    owner   => $user,
    group   => $group,
  }

  file { "$nap_cfg_dir/naprc":
    ensure  => file,
    content => template('nap/server/naprc.erb'),
  }

  file { $napps_puppet:
    ensure => directory,
  }

  file { $napps_file:
    ensure  => file,
    content => template('nap/server/napps.erb'),
  }


  # ... TODO ...
}
