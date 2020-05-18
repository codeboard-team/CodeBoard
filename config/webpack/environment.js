const { environment } = require('@rails/webpacker');

const webpack = require('webpack');

// resolve-url-loader must be used before sass loader

environment.laoder.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader',
  options: {
    attempts: 1
  }
});

// add an additional plugin of your choosing : provideplugin

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
    axios: 'axios',
    Popper: ['popper.js', 'default'],
  })
)

const aliasConfig = {
  'jquery': 'jquery-ui-dist/external/jquery.js',
  'jquery-ui': 'jquery-ui-dist/jquery-ui.js'
};

environment.config.set('resolve.alias', aliasConfig);
module.exports = environment