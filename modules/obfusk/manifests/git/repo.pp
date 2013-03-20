# --                                                            # {{{1
#
# File        : modules/obfusk/manifests/git/repo.pp
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-03-20
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

define obfusk::git::repo (
  $source,
  $path         = $title,
  $branch       = undef,
  $pull         = false,
) {
  if ($branch == undef) {
    $branch_opt = ''
  } else {
    $branch_opt = "-b $branch"
  }

  exec { "git clone => $path":
    command     => "git clone $branch_opt $source $path",
    creates     => "$path/.git",
  }

  if ($pull == true) {
    exec { "git pull => $path":
      command   => 'git pull',
      cwd       => $path,
      logoutput => true,
    }

    Exec["git clone => $path"] -> Exec["git pull => $path"]
  }
}

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
