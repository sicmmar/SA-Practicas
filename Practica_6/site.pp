node 'puppetdev' {
  include 'docker'

  docker::run { 'app-site':
    image   => 'sicmmar/app-practica6:latest',
    ports   => ['8081:80']
  }
}

node 'puppetprod' {
  include 'docker'

  docker::run { 'app-site':
    image   => 'sicmmar/app-practica6:latest',
    ports   => ['8082:80']
  }
}

node default {
  notify { 'this node did not match any of the listed definitions': }
}
