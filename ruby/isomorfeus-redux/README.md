# isomorfeus-redux

Redux for Opal Ruby.

## Versioning
isomorfeus-redux version follows the Redux version which features and API it implements.
Isomorfeus-redux 4.0.x implements features and the API of Redux 4.0 and should be used with Redux4.0

## Installation
To install redux with the matching version:
```
yarn add redux@4.0.0
```
then add to the Gemfile:
```ruby
gem 'isomorfeus-redux'
```
then `bundle install`
and to your client code add:
```ruby
require 'isomorfeus-redux'
```
## Usage
Because isomorfeus-redux follows closely the Redux principles/implementation/API and Documentation, most things of the official Redux documentation
apply, but in the Ruby way, see:
- https://redux.js.org

Redux and accompanying libraries must be imported and available in the global namespace in the application javascript entry file,
with webpack this can be ensured by assigning them to the global namespace:
```javascript
import * as Redux from 'redux';
global.Redux = Redux;
```

Following features are presented with its differences to the Javascript Redux implementation.
Of course, in Ruby the naming is underscored, eg. `Redux.createStore` in javascript becomes `Redux.create_store` in Ruby.

### Creating a Store
A store can be created using:
```ruby
store = Redux::Store.new(reducer, preloaded_state, enhancer)
```
or:
```ruby
store = Redux.create_store(reducer, preloaded_state, enhancer)
```
- **reducer** is a javascript function. Isomorfeus provides a helper to create a reducer, see below.
- **preloaded_state** can be a Ruby Hash or a native javascript object.
- **enhancer** is a javascript function.

### Creating a Reducer
Its possible to use native javascript functions for creating a store. To use ruby conveniently for reducers a helper is provided:
```ruby
reducer = Redux.create_reducer do |prev_state, action|
  # do something here 
  {}.merge(prev_state) 
end
```
This helper wraps the ruby code block in a javascript function that takes care of converting Opal Hashes to javascript
objects and the other way around. The resulting reducer is simply javascript function, suitable for creating a store.

### Other Rubyfications
- `dispatch` accepts a Ruby Hash
- `store.get_state` returns a Ruby Hash
- `subscribe` accepts a ruby block as listener:
```ruby
store.subscribe do
  # something useful here
end
```

### Development Tools
The Redux Development Tools allow for detailed debugging of store/state changes: https://github.com/zalmoxisus/redux-devtools-extension