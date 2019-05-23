Isomorfeus::Installer.add_rack_server('agoo', {
  gems: [ { name: 'agoo', version: "~> 2.8.3" } ],
  start_command: 'bundle exec rackup -s agoo'
})

Isomorfeus::Installer.add_rack_server('falcon', {
  gems: [ { name: 'falcon', version: "~> 0.30.0", require: false } ],
  start_command: 'bundle exec falcon serve'
})

Isomorfeus::Installer.add_rack_server('iodine', {
  gems: [ { name: 'iodine', version: "~> 0.7.31", require: false } ],
  start_command: 'bundle exec iodine'
})

Isomorfeus::Installer.add_rack_server('puma', {
  gems: [ { name: 'puma', version: "~> 3.12.1", require: false } ],
  start_command: 'bundle exec puma'
})
