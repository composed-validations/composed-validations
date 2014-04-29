module.exports = {
  entry: "./lib/browser.coffee",
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
