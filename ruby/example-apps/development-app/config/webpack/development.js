// require requirements used below
const path = require('path');
const webpack = require('webpack');
const chokidar = require('chokidar'); // for watching app/view
const WebSocket = require('ws');
const OwlResolver = require('opal-webpack-loader/resolver'); // to resolve ruby files
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

module.exports = {
    parallelism: 8,
    context: path.resolve(__dirname, '../../app/isomorfeus'),
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
        app: ['./app.js'], // entrypoint for isomorfeus
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
        ],
        alias: {
            'react-dom': 'react-dom/profiling',
            'schedule/tracing': 'schedule/tracing-profiling',
        }
    },
    plugins: [
        // both for hot reloading
        new webpack.NamedModulesPlugin(),
        new webpack.HotModuleReplacementPlugin(),
        new BundleAnalyzerPlugin()
    ],
    module: {
        rules: [
            {
                // loader for .scss files
                // test means "test for for file endings"
                test: /.scss$/,
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
                test: /.css$/,
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
                test: /.(png|svg|jpg|gif)$/,
                use: [
                    'file-loader'
                ]
            },
            {
                test: /.(woff|woff2|eot|ttf|otf)$/,
                use: [
                    'file-loader'
                ]
            },
            {
                // opal-webpack-loader will compile and include ruby files in the pack
                test: /.(rb|js.rb)$/,
                use: [
                    'opal-webpack-loader'
                ]
            }
        ]
    },
    // configuration for webpack-dev-server
    devServer: {
        open: false,
        lazy: false,
        port: 3035,
        hotOnly: true,
        inline: true,
        headers: {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, PATCH, OPTIONS",
            "Access-Control-Allow-Headers": "X-Requested-With, content-type, Authorization"
        }
    }
};

