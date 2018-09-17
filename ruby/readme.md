# Ruby version for Isomorfeus

## Gemfile

Include this repo for development in your Gemfile can be done like this:

```ruby
gem 'isomorfeus-component', :git => 'https://github.com/isomorfeus-org/isomorfeus', :glob => 'ruby/isomorfeus-component/*.gemspec', branch: 'ulysses'
gem 'isomorfeus-#{component_name}', :git => 'https://github.com/isomorfeus-org/isomorfeus', :glob => 'ruby/isomorfeus-#{component_name}/*.gemspec', branch: 'ulysses'
```
