node puppetdev {
  class { 'docker':
    use_upstream_package_source => false,
    version => '17.09.0~ce-0~debian',
  }

  docker::image { 'sicmmar/app-practica6:latest':
    ensure => absent
  }

  docker::run { 'app-site':
    image   => 'sicmmar/app-practica6:latest',
    ports   => ['8081:80']
  }
}

node puppetprod {
  class { 'docker':
    use_upstream_package_source => false,
    version => '17.09.0~ce-0~debian',
  }

  docker::image { 'sicmmar/app-practica6:latest':
    ensure => absent
  }

  docker::run { 'app-site':
    image   => 'sicmmar/app-practica6:latest',
    ports   => ['8082:80']
  }
}
