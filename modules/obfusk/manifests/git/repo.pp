define obfusk::git::repo (
  $source,
  $path   = $title,
  $branch = undef,
  $pull   = false,
) {
  if ($branch == undef) {
    $branch_opt = ""
  } else {
    $branch_opt = "-b $branch"
  }

  exec { "git clone => $path":
    command => "git clone $branch_opt $source $path",
    creates => $path,
  }

  if ($pull == true) {
    exec { "git pull => $path":
      command => "git pull",
      cwd     => $path,
    }
    Exec["git clone => $path"] -> Exec["git pull => $path"]
  }
}
