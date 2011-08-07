$(document).ready(function() {
	var isMobile = demo_layer_url.match(/layer=mobile/);
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
					konaCloseLayer();
                }
            });
			var translation = '(' + -1*window.innerWidth + 'px,0,0)';
			show = function() {
				if(isMobile) {
					layer.load(function() {
						if(frames[0].animation_direction === 'horizontal'){
						}
						layer.show().css('position', 'absolute').offset({left:$(window).scrollLeft() + window.innerWidth, top:$(window).scrollTop() -10})
						.css('-webkit-transform','translate3d' + translation)
						.css({
								'-webkit-transition': '-webkit-transform 0.2s ease-in',
								'-webkit-backface-visibility': 'hidden',
								'-webkit-perspective':'1000'
								});
					});
				} else {
						layer.show(2000).css('position', 'absolute').offset({left:jqthis.offset().left, top:jqthis.offset().top});
				}
			};
			hide = function() {
				if(isMobile) {
					layer.css('-webkit-transform','translate3d' + translation)
						.css({
								'-webkit-transition': '-webkit-transform 1s ease-in-out',
								'-webkit-backface-visibility': 'hidden',
								'-webkit-perspective':'1000'
								});
					setTimeout(function() {layer.hide();}, 500);
				} else {
					layer.hide();
				}
			};
			konaCloseLayer = function() {
				hide();
			};
        }
		show();
    })
    $(".YLight").mouseout(function() {
        console.log('mouse out HL');
        var jqthis = $(this);
        jqthis.data('mouseover', false);
        setTimeout(function() {
            if (!jqthis.data('layer') || jqthis.data('layer').data('mouseover')) {
                return;
            }
            //jqthis.data('layer').hide('slow');
			konaCloseLayer();
        }, 1000);
    })

});
