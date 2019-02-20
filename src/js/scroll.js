
fetch('https://iicvjepx31.execute-api.us-east-1.amazonaws.com/test/api').then(function(data) {
    return data.json();
}).then(function(data) {
    count = 0;
    data.data.forEach(function(el) {
        if (count === 0 || count % 3 === 0) {
            $('.photos').append('<div class="row"></div');
        }

        $('.row').last().append('<div class="col-4 center"><a class ="popup" href="' + el.images.standard_resolution.url + '"><img class="gray horizontal-align vertical-align image" src="' + el.images.standard_resolution.url + '"></a></div>')

        count++;

    })
    $('.popup').magnificPopup({
        type: 'image',
        mainClass: 'mfp-with-zoom', // this class is for CSS animation below
        callbacks: {
            close: function() {
                    if (window.getSelection) {
                        if (window.getSelection().empty) { // Chrome
                            window.getSelection().empty();
                        } else if (window.getSelection().removeAllRanges) { // Firefox
                            window.getSelection().removeAllRanges();
                        }
                    } else if (document.selection) { // IE?
                        document.selection.empty();
                    }
                
            }
        },
        zoom: {
            enabled: true, // By default it's false, so don't forget to enable it

            duration: 300, // duration of the effect, in milliseconds
            easing: 'ease-in-out', // CSS transition easing function

            // The "opener" function should return the element from which popup will be zoomed in
            // and to which popup will be scaled down
            // By defailt it looks for an image tag:
            opener: function(openerElement) {
                // openerElement is the element on which popup was initialized, in this case its <a> tag
                // you don't need to add "opener" option if this code matches your needs, it's defailt one.
                return openerElement.is('img') ? openerElement : openerElement.find('img');
            }
        }
    });

})

$(document).ready(function() {

    $("body").css("visibility", "visible");
});