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

## Example Apps
- [Basic Rails React](https://github.com/isomorfeus/isomorfeus-react/tree/master/ruby/example-apps/basic-rails-react) -
It shows usage of basic React::Components in a rails app
- [Components App](https://github.com/isomorfeus/isomorfeus-react/tree/master/ruby/example-apps/basic-rails-react) -
Shows all Component types and usage of the Store in a rails app