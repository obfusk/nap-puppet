define git::repo ($path = $title, $source, $pull = false) {
  exec { "git clone $source $path":
    creates => $path,
  }

  if ($pull == true) {
    exec { "git pull ($path)":
      command =>  "git pull",
      cwd     => $path
    }
    Exec["git clone $source $path"] -> Exec["git pull ($path)"]
  }
}
