# Ruby version of Isomorfeus

This implementation is based on:
- [isomorfues-redux](https://github.com/isomorfeus/isomorfeus-redux/tree/master/ruby)
- [isomorfeus-react](https://github.com/isomorfeus/isomorfeus-react/tree/master/ruby)

No installation instructions yet.
To play and start developing currently the recommended way is to clone one of the example apps and:
- yarn install
- bundle install
- yarn run start
- bundle exec rails s

For production performance, for example:
- yarn run build
- bundle exec rails s -e production

There are issues with hot reloading at the moment.


### Dependencies

For full functionality the following are required:
- [Opal ES6 import export](https://github.com/opal/opal/pull/1832)
- [Opal Webpack Loader](https://github.com/janbiedermann/opal-webpack-loader)
- [Opal Autoloader](https://github.com/janbiedermann/opal-autoloader)

For the Gemfile:
```ruby
gem 'opal', github: 'janbiedermann/opal', branch: 'es6_import_export'
gem 'opal-webpack-loader', '~> 0.3.7'
gem 'opal-autoloader', '~> 0.0.3'
```

## Example Apps
- [Basic Rails React](https://github.com/isomorfeus/isomorfeus-framework/tree/ulysses/ruby/example-apps/basic-rails-react) -
It shows usage of basic React::Components in a rails app
- [Components App](https://github.com/isomorfeus/isomorfeus-framework/tree/ulysses/ruby/example-apps/components-app) -
Shows all Component types and usage of the Store in a rails app