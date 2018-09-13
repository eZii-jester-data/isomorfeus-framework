<div class="githubisomorfeusheader">

<p align="center">

<a href="http://ruby-isomorfeus.io/" alt="Isomorfeus" title="Isomorfeus">
<img width="350px" src="http://ruby-isomorfeus.io/images/isomorfeus-github-logo.png">
</a>

</p>

<h2 align="center">The Complete Isomorphic Ruby Framework</h2>

<br>

<a href="http://ruby-isomorfeus.io/" alt="Isomorfeus" title="Isomorfeus">
<img src="http://ruby-isomorfeus.io/images/githubisomorfeusbadge.png">
</a>

<a href="https://gitter.im/ruby-isomorfeus/chat" alt="Gitter chat" title="Gitter chat">
<img src="http://ruby-isomorfeus.io/images/githubgitterbadge.png">
</a>

[![Build Status](https://travis-ci.org/ruby-isomorfeus/isomorfeus-store.svg?branch=master)](https://travis-ci.org/ruby-isomorfeus/isomorfeus-store)
[![Codeship Status for ruby-isomorfeus/isomorfeus-store](https://app.codeship.com/projects/4454c560-d4ea-0134-7c96-362b4886dd22/status?branch=master)](https://app.codeship.com/projects/202301)
[![Gem Version](https://badge.fury.io/rb/isomorfeus-store.svg)](https://badge.fury.io/rb/isomorfeus-store)

<p align="center">
<img src="http://ruby-isomorfeus.io/images/HyperStores.png" width="100" alt="Hyperstores">
</p>

</div>

## Isomorfeus-Store GEM is part of Isomorfeus GEMS family

Build interactive Web applications quickly. Isomorfeus encourages rapid development with clean, pragmatic design. With developer productivity as our highest goal, Isomorfeus takes care of much of the hassle of Web development, so you can focus on innovation and delivering end-user value.

One language. One model. One set of tests. The same business logic and domain models running on the clients and the server. Isomorfeus is fully integrated with Rails and also gives you unfettered access to the complete universe of JavaScript libraries (including React) from within your Ruby code. Isomorfeus lets you build beautiful interactive user interfaces in Ruby.

Everything has a place in our architecture. Components deliver interactive user experiences, Operations encapsulate business logic, Models magically synchronize data between clients and servers, Policies govern authorization and Stores hold local state. 

**Stores** are where the state of your Application lives. Anything but a completely static web page will have dynamic states that change because of user inputs, the passage of time, or other external events.

**Stores are Ruby classes that keep the dynamic parts of the state in special state variables**

## Getting Started

1. Update your Gemfile:
        
```ruby
#Gemfile

gem 'isomorfeus'
```

2. At the command prompt, update your bundle :

        $ bundle update

3. Run the isomorfeus install generator:

        $ rails g isomorfeus:install

4. Follow the guidelines to start developing your application. You may find
   the following resources handy:
    * [Getting Started with Isomorfeus](http://ruby-isomorfeus.io/start/components/)
    * [Isomorfeus Guides](http://ruby-isomorfeus.io/docs/architecture)
    * [Isomorfeus Tutorial](http://ruby-isomorfeus.io/tutorials)

## Community

#### Getting Help
Please **do not post** usage questions to GitHub Issues. For these types of questions use our [Gitter chatroom](https://gitter.im/ruby-isomorfeus/chat) or [StackOverflow](http://stackoverflow.com/questions/tagged/isomorfeus).

#### Submitting Bugs and Enhancements
[GitHub Issues](https://github.com/ruby-isomorfeus/isomorfeus/issues) is for suggesting enhancements and reporting bugs. Before submiting a bug make sure you do the following:
* Check out our [contributing guide](https://github.com/ruby-isomorfeus/isomorfeus/blob/master/CONTRIBUTING.md) for info on our release cycle.

## License

Isomorfeus is released under the [MIT License](http://www.opensource.org/licenses/MIT).
