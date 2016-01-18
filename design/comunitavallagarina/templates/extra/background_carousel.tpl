{def $home = fetch( content, node, hash( node_id, ezini('NodeSettings','RootNode','content.ini') ) )
     $home_reverse_related = fetch( content, reverse_related_objects, hash( object_id, $home.contentobject_id ) )
     $images = array()}
{foreach $home_reverse_related as $related}
    {if $related.class_identifier|eq('gallery')}
        {set $images = fetch( content, list, hash( parent_node_id, $related.main_node_id ) )}
    {/if}
{/foreach}
{if count($images)|gt(0)}
    <div id="homepage-carousel">
        <div class="action prev" data-action="prev"><</div>
        <div class="action next" data-action="next">></div>
    </div>
    {ezscript_require(array('jquery.bgswitcher.js'))}
    <script>
        var CarouselContainer = $("#homepage-carousel");
        CarouselContainer.bgswitcher({ldelim}images: [{foreach $images as $image}"{$image.data_map.image.content['original'].url|ezroot(no)}"{delimiter},{/delimiter}{/foreach}]{rdelim});
        $('.action',CarouselContainer).bind('click', function(){ldelim}CarouselContainer.bgswitcher($(this).data('action'));{rdelim});
    </script>
{/if}