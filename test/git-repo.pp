Exec {
  path => [ "/usr/local/sbin", "/usr/local/bin", "/usr/sbin",
            "/usr/bin", "/sbin", "/bin" ]
}

obfusk::git::repo { "/home/$id/__TEST__/nap-puppet":
  source  => "https://github.com/obfusk/nap-puppet.git",
  pull    => true,
}
