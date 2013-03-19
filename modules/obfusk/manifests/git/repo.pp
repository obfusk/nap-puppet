define obfusk::git::repo (
  $source,
  $path   = $title,
  $pull   = false,
  $branch = master
) {
  exec { "git clone -b $branch $source $path":
    creates => $path,
  }

  if ($pull == true) {
    exec { "git pull ($path)":
      command =>  "git pull origin $branch",
      cwd     => $path
    }
    Exec["git clone $source $path"] -> Exec["git pull ($path)"]
  }
}
