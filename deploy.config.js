var webpack = require("webpack");
var glob = require("glob");
var path = require("path");
module.exports = {
  entry: "./start.js",
  target: "node",
  output: {
    path: process.cwd(),
    filename: "index.js",
    libraryTarget: "commonjs2"
  },
  externals: {
    // aws-sdk does not (currently) build correctly with webpack. However,
    // Lambda includes it in its environment, so omit it from the bundle.
    // See: https://github.com/apex/apex/issues/217#issuecomment-194247472
    "aws-sdk": "aws-sdk"
  },
  module: {
    loaders: [
      {
        test: /\.json$/,
        loader: "json-loader"
      }
    ]
  }
};
