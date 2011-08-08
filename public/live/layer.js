$(document).ready(function() {
	$ = $KKK;
	var isMobile = demo_layer_url.match(/layer=mobile|layer=balls/) 
    $(".YLight").css('background-color', 'yellow')
    $(".YLight").mouseover(function() {
        console.log('mouse over HL');
        var jqthis = $(this);
        jqthis.data('mouseover', true);
        var layer = jqthis.data('layer');
        if (!layer) {
            layer = $('<iframe>')
                .attr({
                    src: demo_layer_url,
                    frameborder:0,
                    width: window.innerWidth,
					height: window.innerHeight
                });
			if(!isMobile) {
				layer.css('position', 'absolute').offset({left:jqthis.offset().left, top:jqthis.offset().top});
				layer.hide();
			} else {
				layer.css({
						position: 'absolute',
						left:$(window).scrollLeft() + window.innerWidth, 
						top:$(window).scrollTop() -10});

				layer.css({
					'-webkit-transition-property':'all',
					'-webkit-transition-duration': '200ms'});
			};

            $('body').append(layer);
            jqthis.data('layer', layer);
            console.log('create a new layer');
            layer.data('highlight', jqthis);
            layer.mouseover(function() {
                console.log('mouse over layer');
                layer.data('mouseover', true);
            });
            layer.mouseout(function() {
                console.log('mouse out layer');
                layer.data('mouseover', false);
                if (!layer.data('highlight').data('mouseover')) {
					if(!window.kona_never_close) {
						konaCloseLayer();
					}
                }
            });
			show = function() {
				if(!isMobile) {
					layer.show(2000);
				} else {
					layer.css('left', '0px');
				}
			}
			hide = function() {
				if(isMobile) {
					layer.css('left', '-' + window.innerWidth + 'px');
				} else {
					layer.hide();
				}
			};
			konaCloseLayer = function() {
				if(window.kona_never_close) return;
				hide();
			};
			layer.load(show);
        } else {
			console.log('layer exists');
			show();
		}
    })
    $(".YLight").mouseout(function() {
        console.log('mouse out HL');
        var jqthis = $(this);
        jqthis.data('mouseover', false);
        setTimeout(function() {
            if (!jqthis.data('layer') || jqthis.data('layer').data('mouseover')) {
                return;
            }
            jqthis.data('layer').hide('slow');
			if(!window.kona_never_close) {
				konaCloseLayer();
			}
        }, 1000);
    })

});
