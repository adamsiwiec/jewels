module.exports = {
  /**
   * Application configuration section
   * http://pm2.keymetrics.io/docs/usage/application-declaration/
   */
  apps : [

    // First application
    {
      name      : 'WEB',
      script    : 'index.js',
      "instances" : 0,
      "exec_mode" : "cluster",
      env: {
        NODE_ENV: 'production',
        PORT: '80'

      },
      env_production : {
        NODE_ENV: 'production',
        PORT: '80'
      }
    }
  ]

  /**
   * Deployment section
   * http://pm2.keymetrics.io/docs/usage/deployment/
   */
};
