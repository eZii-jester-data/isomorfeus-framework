# Isomorfeus Framework Installer

Create new isomorfeus applications with ease.

#### Supported Frameworks
- Cuba
- Rails
- Roda
- Sinatra

#### Supported Isomorfeus modules
- isomorfeus-react
- isomorfeus-redux

#### Supported asset bundlers
- webpack with opal-webpack-loader

## Installation
```bash
gem install isomorfeus-installer
```

## Creating new applications
After running the installer execute:
```bash
bundle install
yarn install
```
to install all gems and npms.

### Options
```bash
isomorfeus -h
```
```
Usage: isomorfeus options...

Required:
    -n, --new=NAME                   Create new project with NAME and install isomorfeus.

Also required in any case is:
    -f, --framework=FRAMEWORK        Select base Framework, one of: cuba, rails, roda, sinatra.

Other options:
    -a, --asset-bundler=BUNDLER      Select asset bundler, one of: owl. (optional)

    -h, --help                       Prints this help
```
### Examples
Creating a **Cuba** app with opal-webpack-loader as asset bundler:
```bash
isomorfeus --new=my_app --framework=cuba --asset-bundler=owl
```
Short form:
```bash
isomorfeus -nmy_app -fcuba -aowl
```
Creating a **Rails** app with opal-webpack-loader as asset bundler:
```bash
isomorfeus --new=my_app --framework=rails --asset-bundler=owl
```
Creating a **Roda** app with opal-webpack-loader as asset bundler:
```bash
isomorfeus --new=my_app --framework=roda --asset-bundler=owl
```
Creating a **Sinatra** app with opal-webpack-loader as asset bundler:
```bash
isomorfeus --new=my_app --framework=rsinatra --asset-bundler=owl
```
