
group{'peter':
  ensure => present
}
group{'jenkins':
  ensure => present
}

user{'jenkins':
  ensure => present,
  home => '/data/ci/jenkins',
  gid => 'jenkins',
  groups => ['docker'],
  comment => 'Jenkins CI/CD system',
  require => Group['jenkins']
}

file{'/data/ci/jenkins':
  ensure => 'directory',
  owner => 'jenkins',
  group => 'jenkins',
  mode => '0700',
  require => User['jenkins']
}

group{'peter':
  ensure => present
}
user{'peter':
  ensure => present,
  gid => 'peter',
  groups => ['sudo','docker'],
  comment => 'Peter L. Berghold',
  home => '/ddta/home/peter',
  shell => '/bin/bash',
  require => Group['peter']
}

file{'/data/home/peter':
  ensure => directory,
  owner => 'peter',
  group => 'peter',
  mode => '0700',
  require => User['peter']
}

