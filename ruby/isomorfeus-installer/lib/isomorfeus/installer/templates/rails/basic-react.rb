# Isomorfeus Basic Template

##  Commit base rails for we have a full commit history

git :init
git add:    "."
git commit: "-m 'Initial commit: Rails base'"

##  Add the gems

gem 'opal', github: 'janbiedermann/opal', branch: 'es6_import_export'
gem 'opal-autoloader', '~> 0.0.2'
gem 'isomorfeus-react', github: 'isomorfeus/isomorfeus-framework', branch: 'ulysses', glob: 'ruby/isomorfeus-react/*.gemspec'

# ----------------------------------- Create the folders

run 'mkdir app/isomorfeus'
run 'mkdir app/isomorfeus/components'

# ----------------------------------- Add .keep files

file 'app/isomorfeus/components/.keep', ''

# ----------------------------------- Create the Isomorfeus loader file

file 'app/isomorfeus/isomorfeus_webpack_loader.rb', <<-CODE
require 'opal'
require 'opal-autoloader'
require 'isomorfeus-react'

require_tree 'components'
CODE

# ----------------------------------- Create isomorfeus.js

file 'app/javascript/app.js', <<-CODE
import React from 'react';
import ReactDOM from 'react-dom';
import * as History from 'history';
import * as ReactRouter from 'react-router';
import * as ReactRouterDOM from 'react-router-dom';
import ActionCable from 'actioncable';

global.React = React;
global.ReactDOM = ReactDOM;
global.History = History;
global.ReactRouter = ReactRouter;
global.ReactRouterDOM = ReactRouterDOM;
global.ActionCable = ActionCable;

import init_app from 'isomorfeus_webpack_loader.rb';

init_app();
Opal.load('isomorfeus_webpack_loader');
if (module.hot) {
    module.hot.accept('./app.js', function () {
        console.log('Accepting the updated Isomorfeus module!');
    })
}
CODE

# ----------------------------------- Create webpack config development.js

file 'config/webpack/development.js', <<-CODE
// require requirements used below
const path = require('path');
const webpack = require('webpack');
const chokidar = require('chokidar'); // for watching app/view
const WebSocket = require('ws');
const OwlResolver = require('opal-webpack-loader/resolver'); // to resolve ruby files

module.exports = {
    parallelism: 8,
    context: path.resolve(__dirname, '../..'),
    mode: "development",
    optimization: {
        minimize: false // dont minimize in development, to speed up hot reloads
    },
    performance: {
        maxAssetSize: 20000000, // isomorfeus is some code
        maxEntrypointSize: 20000000
    },
    // use this or others below, disable for faster hot reloads
    devtool: 'source-map', // this works well, good compromise between accuracy and performance
    // devtool: 'cheap-eval-source-map', // less accurate
    // devtool: 'inline-source-map', // slowest
    // devtool: 'inline-cheap-source-map',
    entry: {
        app: ['./app/javascript/app.js'], // entrypoint for isomorfeus
    },
    output: {
        // webpack-serve keeps the output in memory
        filename: '[name]_development.js',
        path: path.resolve(__dirname, '../../public/packs'),
        publicPath: 'http://localhost:3035/packs/'
    },
    resolve: {
        plugins: [
            // this makes it possible for webpack to find ruby files
            new OwlResolver('resolve', 'resolved')
        ]
    },
    plugins: [
        // both for hot reloading
        new webpack.NamedModulesPlugin()
    ],
    module: {
        rules: [
            {
                // loader for .scss files
                // test means "test for for file endings"
                test: /\.scss$/,
                use: [
                    {
                        loader: "style-loader",
                        options: {
                            hmr: true
                        }
                    },
                    {
                        loader: "css-loader",
                        options: {
                            sourceMap: true, // set to false to speed up hot reloads
                            minimize: false // set to false to speed up hot reloads
                        }
                    },
                    {
                        loader: "sass-loader",
                        options: {
                            includePaths: [path.resolve(__dirname, '../../app/assets/stylesheets')],
                            sourceMap: true // set to false to speed up hot reloads
                        }
                    }
                ]
            },
            {
                // loader for .css files
                test: /\.css$/,
                use: [
                    {
                        loader: "style-loader",
                        options: {
                            hmr: true
                        }
                    },
                    {
                        loader: "css-loader",
                        options: {
                            sourceMap: true, // set to false to speed up hot reloads
                            minimize: false // set to false to speed up hot reloads
                        }
                    }
                ]
            },
            {
                test: /\.(png|svg|jpg|gif)$/,
                use: [
                    'file-loader'
                ]
            },
            {
                test: /\.(woff|woff2|eot|ttf|otf)$/,
                use: [
                    'file-loader'
                ]
            },
            {
                // opal-webpack-loader will compile and include ruby files in the pack
                test: /\.(rb|js.rb)$/,
                use: [
                    'opal-webpack-loader'
                ]
            }
        ]
    },
    // configuration for webpack serve
    serve: {
        devMiddleware: {
            publicPath: '/packs/',
            headers: {
                'Access-Control-Allow-Origin': '*'
            },
            watchOptions: {

            }
        },
        hotClient: {
            host: 'localhost',
            port: 8081,
            allEntries: true,
            hmr: true
        },
        host: "localhost",
        port: 3035,
        logLevel: 'debug',
        content: path.resolve(__dirname, '../../public/packs'),
        clipboard: false,
        open: false,
        on: {
            "listening": function (server) {
                const socket = new WebSocket('ws://localhost:8081');
                const watchPath = path.resolve(__dirname, '../../app/views');
                const options = {};
                const watcher = chokidar.watch(watchPath, options);

                watcher.on('change', () => {
                    const data = {
                        type: 'broadcast',
                        data: {
                            type: 'window-reload',
                            data: {},
                        },
                    };

                    socket.send(JSON.stringify(data));
                });

                server.server.on('close', () => {
                    watcher.close();
                });
            }
        }
    }
};

CODE

# ----------------------------------- Create webpack config production.js

file 'config/webpack/production.js', <<-CODE
const path = require('path');
const OwlResolver = require('opal-webpack-loader/resolver');
const CompressionPlugin = require("compression-webpack-plugin"); // for gzipping the packs
const ManifestPlugin = require('webpack-manifest-plugin');  // for generating the manifest

module.exports = {
    parallelism: 8,
    context: path.resolve(__dirname, '../..'),
    mode: "production",
    optimization: {
        minimize: true // minimize
    },
    performance: {
        maxAssetSize: 20000000, // isomorfeus is some code
        maxEntrypointSize: 20000000
    },
    entry: {
        app: './app/javascript/app.js',
    },
    plugins: [
        new CompressionPlugin({ test: /\.js/ }), // gzip compress
        new ManifestPlugin() // generate manifest
    ],
    output: {
        filename: '[name]-[chunkhash].js', // include fingerprint in file name, so browsers get the latest
        path: path.resolve(__dirname, '../../public/packs'),
        publicPath: '/packs/'
    },
    resolve: {
        plugins: [
            // resolve ruby files
            new OwlResolver('resolve', 'resolved')
        ]
    },
    module: {
        rules: [
            {
                test: /\.scss$/,
                use: [
                    {
                        loader: "style-loader",
                        options: {
                            hmr: false
                        }
                    },
                    {
                        loader: "css-loader"
                    },
                    {
                        loader: "sass-loader",
                        options: {
                            includePath: [
                                path.resolve(__dirname, '../../app/assets/stylesheets')
                            ]
                        }
                    }
                ]
            },
            {
                test: /\.css$/,
                use: [
                    'style-loader',
                    'css-loader'
                ]
            },
            {
                test: /\.(png|svg|jpg|gif)$/,
                use: [
                    'file-loader'
                ]
            },
            {
                test: /\.(woff|woff2|eot|ttf|otf)$/,
                use: [
                    'file-loader'
                ]
            },
            {
                // compile and load ruby files
                test: /\.(rb|js.rb)$/,
                use: [
                    'opal-webpack-loader'
                ]
            }
        ]
    }
};

CODE

# create config for test.js
file 'config/webpack/test.js', <<-CODE
const path = require('path');
const webpack = require('webpack');
const OwlResolver = require('opal-webpack-loader/resolver');

module.exports = {
    parallelism: 8,
    context: path.resolve(__dirname, '../..'),
    mode: "test",
    optimization: {
        minimize: false
    },
    performance: {
        maxAssetSize: 20000000,
        maxEntrypointSize: 20000000
    },
    entry: {
        app: './app/javascript/app.js',
    },
    output: {
        filename: '[name]_test.js',
        path: path.resolve(__dirname, '../../public/packs'),
        publicPath: '/packs/'
    },
    resolve: {
        plugins: [
            new OwlResolver('resolve', 'resolved')
        ]
    },
    module: {
        rules: [
            {
                test: /\.scss$/,
                use: [
                    { loader: "style-loader" },
                    { loader: "css-loader" },
                    {
                        loader: "sass-loader",
                        options: {
                            includePaths: [path.resolve(__dirname, '../../app/assets/stylesheets')]
                        }
                    }
                ]
            },
            {
                test: /\.css$/,
                use: [
                    'style-loader',
                    'css-loader'
                ]
            },
            {
                test: /\.(png|svg|jpg|gif)$/,
                use: [
                    'file-loader'
                ]
            },
            {
                test: /\.(woff|woff2|eot|ttf|otf)$/,
                use: [
                    'file-loader'
                ]
            },
            {
                test: /\.(rb|js.rb)$/,
                use: [
                    'opal-webpack-loader'
                ]
            }
        ]
    }
};


CODE

# ----------------------------------- Scripts for package.json

inject_into_file 'package.json', after: %r{"dependencies": {}} do
  <<-CODE
  ,
  "scripts": {
    "test": "bundle exec opal-webpack-compile-server kill; bundle exec opal-webpack-compile-server && webpack --config=config/webpack/test.js; bundle exec opal-webpack-compile-server kill",
    "start": "bundle exec opal-webpack-compile-server kill; bundle exec opal-webpack-compile-server && bundle exec webpack-serve --config ./config/webpack/development.js; bundle exec opal-webpack-compile-server kill",
    "build": "bundle exec opal-webpack-compile-server kill; bundle exec opal-webpack-compile-server && webpack --config=config/webpack/production.js; bundle exec opal-webpack-compile-server kill"
  }
  CODE
end

# ----------------------------------- Add NPM modules

run 'yarn add react'
run 'yarn add react-dom'
run 'yarn add react-router'
run 'yarn add react-router-dom'
run 'yarn add opal-webpack-loader'
run 'yarn add -D webpack-serve'
run 'yarn add webpack-cli'
run 'yarn add -D compression-webpack-plugin'
run 'yarn add -D webpack-manifest-plugin'

## ----------------------------------- Add to application_helper

inject_into_file 'app/helpers/application_helper.rb', after: 'module ApplicationHelper' do
<<-CODE

  include OpalWebpackLoader::RailsViewHelper
CODE
end

# ----------------------------------- View template

inject_into_file 'app/views/layouts/application.html.erb', after: %r{<%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>} do
  <<-CODE

    <%= owl_script_tag '/packs/app.js' %>
  CODE
end

# ----------------------------------- Procfile

file 'Procfile', <<-CODE
app  :         bundle exec puma
webpack_serve: yarn run start
CODE

# ----------------------------------- Commit Isomorfeus setup

after_bundle do
  git add:    "."
  git commit: "-m 'Isomorfeus config complete'"
end