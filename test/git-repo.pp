Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
}

obfusk::git::repo { "/home/vagrant/nap-puppet__TEST":
  source  => "https://github.com/obfusk/nap-puppet.git",
  pull    => true,
}
