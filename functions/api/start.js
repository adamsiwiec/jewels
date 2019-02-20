var Instagram = require('node-instagram').default;
var request = require('request');

var token;

exports.handle = (event, context, callback) => {
  // request.get('http://instagram.pixelunion.net/#access_token=4999539189.1677ed0.a77fddc2fac74e1d8a5c5c5969880fb6').on('response', (res) => {
  // //console.log(err,res,body);
  // var url = res.toJSON().request.uri.hash
  // token = url.slice(url.indexOf('=') + 1)
  // console.log(token)

var instagram = new Instagram({
            clientID      : '74a051d1f2f74d57af4c3d55c78386b4', // your App ID
        clientSecret  : 'd3e10bb567de45eea9ee7bbe14d8522e', // your App Secret
        accessToken: "4999539189.1677ed0.83bcffbd93614b8f8ef95bdf6bc0ff6e"
})
 instagram.get('users/self/media/recent', function(err,data) {
        if(err) {
          console.log(err);
        }
        callback(err, data);
    });

   // })

 
};