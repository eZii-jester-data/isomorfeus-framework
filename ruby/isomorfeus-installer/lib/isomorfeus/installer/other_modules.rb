Isomorfeus::Installer.add_i18n_module('i18n', {
  gems: [ { name: 'isomorfeus-i18n', version: "~> #{Isomorfeus::Installer::VERSION}" } ]
})

Isomorfeus::Installer.add_operation_module('operation', {
  gems: [ { name: 'isomorfeus-operation', version: "~> #{Isomorfeus::Installer::VERSION}" } ]
})

Isomorfeus::Installer.add_policy_module('policy', {
  gems: [ { name: 'isomorfeus-policy', version: "~> #{Isomorfeus::Installer::VERSION}" } ]
})
