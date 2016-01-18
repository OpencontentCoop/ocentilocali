{def $valid_node = $block.valid_nodes[0]
     $show_link = true()}

{if and( $valid_node|not(), is_set( $block.custom_attributes.source ) )}
    {set $valid_node = fetch( content, node, hash( node_id, $block.custom_attributes.source ) )}
{/if}

{if $valid_node|not()}
    {set $valid_node = fetch( content, node, hash( node_id, ezini( 'NodeSettings', 'RootNode', 'content.ini' ) ) )
         $show_link = false()}
{/if}

{def $calendarDataDay = fetch( openpa, calendario_eventi, hash( 'calendar', $valid_node, 'params', hash( 'interval', 'P1W' ) ) )}
{*if is_set( $block.custom_attributes )}
    {def $calendarDataOther = fetch( openpa, calendario_eventi, hash( 'calendar', $valid_node, 'params', $block.custom_attributes ) )}
{else}
    {def $calendarDataOther = false()}
{/if}
{debug-log var=$calendarDataDay.fetch_parameters msg='Blocco eventi fetch oggi'}
     
{def $day_events = $calendarDataDay.events
     $day_events_count = $calendarDataDay.search_count
     $prossimi = array()
     $prossimi_count = 0}

{if $calendarDataOther}     
{debug-log var=$calendarDataOther.fetch_parameters msg='Blocco eventi fetch secondo tab'}
{set $prossimi = $calendarDataOther.events
     $prossimi_count = $calendarDataOther.search_count}
{/if*}  
{def $children = $calendarDataDay.events}
{if $children|count|gt(0)}
    {ezscript_require(array( 'ezjsc::jquery', 'ui-widgets.js' ) )}
    
    <script type="text/javascript">
    {literal}
    $(function() {
        $("#{/literal}x{$block.id}{literal}").tabs().tabs("rotate", 4000);
        var rotation = true;
        $(".rotation-control").bind('click', function() {
            if (rotation){
                $(this).parent().tabs("rotate", 0);
                rotation = false;
                $(this).removeClass('started');
                $(this).addClass('stopped');
            }else{
                $(this).parent().tabs("rotate", 4000);
                rotation = true;
                $(this).removeClass('stopped');
                $(this).addClass('started');
            }
        });
    });
    {/literal}
    </script>
    
    <div class="block-type-lista block-lista_num">
    
        {if $block.name}
            <h2 class="block-title">
                <a href={$valid_node.url_alias|ezurl()} title="Vai a {$block.name|wash()}">{$block.name}</a>
            </h2>
        {else}
            <h2 class="block-title">
                <a href={$valid_node.url_alias|ezurl()} title="Vai a {$valid_node.name|wash()}">{$valid_node.name}</a>
            </h2>
        {/if}
    
        <div class="border-box box-gray box-numeri">
        <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
        <div class="border-ml"><div class="border-mr"><div class="border-mc">
        <div class="border-content">
        
            <div id="x{$block.id}" class="ui-tabs">	
                        
                <div class="num-tabs-panels">
                {foreach $children as $index => $item}
                {if $item.node}
				{def $child = $item.node}
                    <div id="event-{$child.contentobject_id|slugize()}-{$child.node_id}" class="{if $index|ge(3)}no-js-hide {/if}ui-tabs-hide">
    
                        <div class="attribute-header">
                            <h3>
                            {if $child.class_identifier|eq('link')}
                                    <a href={$child.data_map.location.content|ezurl()} title="Apri il link in una pagina esterna (si lascerà il sito)">{$child.name|wash()}</a>
                            {else}
                                <a{if $index|eq(0)} class="active"{/if} href={$child.url_alias|ezurl()}>{$child.name|wash()}</a>
                            {/if}
                            </h3>
                        </div>
    
                        <div class="attribute-small">
                        {if $child.object.data_map.periodo_svolgimento.has_content}
                            {attribute_view_gui attribute=$child.object.data_map.periodo_svolgimento}
                        {else}
                            {$child.object.data_map.from_time.content.timestamp|datetime(custom,"%j %F")|shorten( 12 , '')}
                            {if and($child.object.data_map.to_time.has_content,  ne( $child.object.data_map.to_time.content.timestamp|datetime(custom,"%j %M"),
                                $child.object.data_map.from_time.content.timestamp|datetime(custom,"%j %M") ))}
                                - {$child.object.data_map.to_time.content.timestamp|datetime(custom,"%j %F")|shorten( 12 , '')}
                            {/if}
                        {/if}
                        </div>
    
                        {if and(is_set($child.data_map.image), $child.data_map.image.has_content)}
                            <div class="attribute-image no-js-hide">
                                {attribute_view_gui attribute=$child.data_map.image image_class=lista_accordion}
                            </div>
                        {else}
                            {include node=$child uri='design:parts/common/class_icon.tpl' css_class="image-medium"} 					   
                        {/if}
                        
                        <div class="no-js-hide">
                            {if and( is_set( $child.data_map.abstract ), $child.data_map.abstract.has_content )}
                                    {attribute_view_gui attribute=$child.data_map.abstract}
                            
                            {elseif and( is_set( $child.data_map.informazioni ), $child.data_map.informazioni.has_content )}
                                {attribute_view_gui attribute=$child.data_map.informazioni}
                            
                            {elseif $child|has_abstract()}
                                <p>{$child|abstract()|openpa_shorten(200)}</p>
                            {/if}
                            
                        </div>		
                                            
                    </div>
                    {if $index|lt(3)}<hr class="no-js-show clear" />{/if}
                {undef $child}
				{/if}
                {/foreach}
                </div>
                
                <div class="rotation-control started no-js-hide"></div>
                <ul class="num-tabs no-js-hide float-break">						 
                {foreach $children as $index => $item}
                {if $item.node}
				{def $child = $item.node}
                    <li><a href="#event-{$child.contentobject_id|slugize()}-{$child.node_id}">{$index|inc()}</a></li>
                  {undef $child}
				{/if}
                {/foreach}
                </ul>			
                
                <div class="no-js-show"><a href={$event_node.url_alias|ezurl()} title="{$event_node.name|wash()}">Vai a {$event_node.name|wash()}<span class="arrow-blue-r"></span></a></div>
                
            </div>
            
        </div>
        </div></div></div>
        <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
        </div>	
    
    </div>
{else}
    <div class="warning"><p>Nessun evento in programma</p></div>
{/if}