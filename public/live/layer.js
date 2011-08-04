$(document).ready(function() {
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
                    width: '100%',
                    height: '100%'
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
                    layer.hide('slow');
                }
            });
        }
        layer.show(2000).css('position', 'absolute').offset({left:jqthis.offset().left, top:jqthis.offset().top})
        /*.animate({
         top: '+=100'
         }, 1000)*/
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
        }, 1000);
    })

});