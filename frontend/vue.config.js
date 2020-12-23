const webpack = require('webpack')

module.exports = {
  "configureWebpack": {
    "plugins": [
        new webpack.DefinePlugin({
            'options': {
              title: 'Activity Loggersss',
            },
            'process.env': {
                title: 'Activity Logger',
                NODE_ENV: JSON.stringify(process.env.NODE_ENV)
            }
        })
    ]
  },
  "transpileDependencies": [
    "vuetify"
  ]
} 