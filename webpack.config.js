module.exports = {
  entry: "./lib/index.coffee",
  output: {
    path: __dirname,
    filename: "composed-validations.js"
  },

  module: {
    loaders: [
      {test: /\.coffee$/, loader: 'coffee-loader'}
    ]
  }
};
