var path = require("path");
var webpack = require("webpack");
const glob = require('glob');
var FaviconsWebpackPlugin = require('favicons-webpack-plugin')

var SRC = path.join(__dirname, 'src/');

module.exports = {
    entry: [SRC],
    output: {
        publicPath: "dist/",
        path: path.join(__dirname, 'dist/'),
        filename: 'app.bundle.js'
    },
    module: {
        loaders: [{
                test: /\.css$/,
                loaders: ['style-loader', {
                    loader: 'css-loader',
                    options: {
                        minimize: true
                    }
                }]

            }, { test: /\.json$/, loader: 'json-loader' },
            {
                test: /\.(gif|png|jpe?g|svg)$/i,
                loaders: [
                    'file-loader?hash=sha512&digest=hex&name=[hash].[ext]',
                    {
                        loader: 'image-webpack-loader',
                        options: {
                            query: {
                                mozjpeg: {
                                    progressive: true,
                                },
                                gifsicle: {
                                    interlaced: true,
                                },
                                optipng: {
                                    optimizationLevel: 7,
                                }
                            }
                        }
                    }
                ]
            },
            {
                test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
                loader: "url-loader?limit=10000&minetype=application/font-woff"
            },
            {
                test: /\.(ttf|eot|otf)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
                loader: "file-loader"
            }
        ]
    },
    resolve: {
        extensions: [ '.webpack.js', '.web.js', '.js']
    },
    node: {
        console: true,
        fs: 'empty',
        net: 'empty',
        tls: 'empty'
    },
    devtool: "source-map",
    plugins: [

        new webpack.ProvidePlugin({
            $: "jquery",
            jQuery: "jquery",
            "window.jQuery": "jquery",
            Typed: "typed.js"
        }),

        new webpack.optimize.UglifyJsPlugin({
            sourceMap: true,
            compress: {
                warnings: false
            }
        }),
        new webpack.LoaderOptionsPlugin({
            options: {
                context: path.resolve(__dirname, '.'),
                output: {
                    path: 'dist',
                },
            }
        }),
        new FaviconsWebpackPlugin({
            logo: './src/img/ruby.png',
            prefix: 'favicons/',
            inject: false,

        })


    ]
};