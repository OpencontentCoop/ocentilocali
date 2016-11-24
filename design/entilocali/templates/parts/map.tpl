{if is_set( $parent_node_id )|not()}
    {def $parent_node_id = ezini( 'NodeSettings', 'RootNode', 'content.ini' )}
{/if}
{if is_set( $class )|not()}
    {def $class = 'luogo'}
{/if}
{if is_set( $height )|not()}
    {def $height = '300px'}
{/if}
{if is_set( $width )|not()}
    {def $width = '100%'}
{/if}
{if is_set( $limit )|not()}
    {def $limit = 5000}
{/if}

{def $filters_hash = hash( 'filter', array( concat(solr_meta_field('geo'),':*' ) ) )}
{def $map_search_hash = hash(
                               'subtree_array', array( $parent_node_id ),
                               'class_id', array( $class ),
                               'limit', $limit
                               )
}

{def $topics_facet =hash(
                               'subtree_array', array( $parent_node_id ),
                               'class_id', array( $class ),
                               'limit', 1,
                               'facet',array(hash('field',solr_meta_subfield('tipo_luogo','id'), limit,14))
                               )
}
{def $filter_attributes = array()}
{def $get_topics = fetch(ezfind, search, $topics_facet)}

{def $map_news = fetch( ezfind, search, $map_search_hash )}

{if $map_news.SearchCount}

<div id="content-research-map">

    <script type="text/javascript" src='http://maps.google.com/maps/api/js?sensor=true'></script>
    {ezscript_require( array( 'ezjsc::jquery', 'jquery.ui.map.min.js', 'ocmap.js' ))}
    <script type="text/javascript">
    {literal}
    $(document).ready( function(){
        $('#map_canvas').ocmap();
        $('#filter_toggle').bind( 'click', function(){
            $('#map_filters input').each( function(){
                $(this).trigger( 'change' );
                $(this).trigger( 'click' );
            });
            return false;
        });
    });
    {/literal}
    </script>
    <div id="map_canvas" style="width:{$width|unit_measure()};height:{$height|unit_measure()};background:#999"></div>
    
    {if count($get_topics.SearchExtras.facet_fields.0.nameList)|gt(0)}
        <a href="#" class="no-js_hide" id="filter_toggle"><small>Inverti selezione</small></a>
        <ul id="map_filters" class="float-break">
        {def $counter = 0}
        
        {foreach $get_topics.SearchExtras.facet_fields.0.nameList as $i}
            {def $item = fetch( 'content', 'object', hash( 'object_id', $i ) )}
            <li class="filter">
                <input class="select" type="checkbox" value="{$item.id}" />
                {if and( is_set( $item.data_map.image ), $item.data_map.image.has_content )}
                    {attribute_view_gui attribute=$item.data_map.image image_class='marker'}
                {else}
                    {class_icon( small, $item.class_identifier )}
                {/if}
                <span data-filter="{$item.id}">{$item.name}</span>
            </li>
            {set $counter = $counter|inc()}
            {undef $item}
        {/foreach}
        </ul>
    {/if}

    {set $filter_attributes = array('tipo_luogo')}
    
    <div id="map_data">
        {foreach $map_news.SearchResult as $result}
            {node_view_gui view='map_line' content_node=$result filter_attributes=$filter_attributes}
        {/foreach}
    </div>

</div>    
{/if}
