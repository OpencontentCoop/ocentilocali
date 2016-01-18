{def $top_menu_class_filter = openpaini( 'TopMenu', 'IdentificatoriMenu', array() )
     $custom_menu = openpaini( 'TopMenu', 'NodiCustomMenu', false() )
     $custom_aree = openpaini( 'TopMenu', 'NodiAreeCustomMenu', array() )
     $main_styles = openpaini( 'Stili', 'Nodo_NomeStile', array() )}


    {if $custom_menu|not()}
        {def $root_node=fetch( 'content', 'node', hash( 'node_id', $pagedata.root_node) )
             $top_menu_items=fetch( 'content', 'list', hash( 'parent_node_id', $root_node.node_id,
                                                              'sort_by', $root_node.sort_array,
                                                              'class_filter_type', 'include',
                                                              'class_filter_array', $top_menu_class_filter,
                                                              'limit', openpaini( 'TopMenu', 'LimitePrimoLivello', 4 ) ) )
             $current_node_in_path = first_set($pagedata.path_array[1].node_id, 0  )
             $current_node_in_path_2 = first_set($pagedata.path_array[2].node_id, 0  )
        }
    {else}
        {def $top_menu_items=array()}
        {foreach $custom_menu as $menu_id}
            {set $top_menu_items = $top_menu_items|append( fetch( 'content', 'node', hash( 'node_id', $menu_id ) )  )}
        {/foreach}
        {def $root_node=false
             $current_node_in_path = first_set($pagedata.path_array[1].node_id, 0  )
             $current_node_in_path_2 = first_set($pagedata.path_array[2].node_id, 0  )}
        {if and( is_set( $pagedata.path_array[1] ), is_set( $pagedata.path_array[1].node_id ), eq($pagedata.path_array[1].node_id, ezini('NodeSettings', 'RootNode', 'content.ini')) )}
            {set $current_node_in_path = first_set($pagedata.path_array[2].node_id, 0  )
                 $current_node_in_path_2 = first_set($pagedata.path_array[3].node_id, 0  )}
        {/if}
    {/if}
    
    {def $level_2_items_count = 0
         $top_menu_items_count = $top_menu_items|count()
         $item_class = array()
         $level_2_items = 0
         $item_class_2 = array()
         $level_3_items= array()
    }

    {if $top_menu_items_count}
       {foreach $top_menu_items as $key => $item}
            {set $item_class = cond($current_node_in_path|eq($item.node_id), array("selected"), array())
                 $level_2_items = 0
                 $level_2_items = fetch( 'content', 'list', hash( 'parent_node_id', $item.node_id,
                                                                'sort_by', $item.sort_array,
                                                                'limit', openpaini( 'TopMenu', 'LimiteSecondoLivello', 20 ),
                                                                'class_filter_type', 'include', 
                                                                'class_filter_array', $top_menu_class_filter ) )}
                                                                          
            {set $item_class = $item_class|append( concat( 'split-', $top_menu_items_count ) )}
            {if $key|eq(0)}
                {set $item_class = $item_class|append("firstli")}
            {/if}
            {if $top_menu_items_count|eq( $key|inc )}
                {set $item_class = $item_class|append("lastli")}
            {/if}
            {if $item.node_id|eq( $current_node_id )}
                {set $item_class = $item_class|append("current")}
            {/if}
            
            {if is_set($main_styles[$item.node_id])}
            {set $item_class = $item_class|append($main_styles[$item.node_id]|slugize())}
            {/if}

                <div class="split-{$top_menu_items_count}">
                    <p><a class="{$item.name|slugize()}" href={if eq( $ui_context, 'browse' )}{concat("content/browse/", $item.node_id)|ezurl}{else}{$item.url_alias|ezurl}{/if}{if $pagedata.is_edit} onclick="return false;"{/if}>
                        <span>{$item.name|wash()}</span>
                    </a></p>
                    {if $level_2_items|count()}
                        <ul class="itemlist-{$key}">
                            {foreach $level_2_items as $key => $item2 sequence array( 'odd', 'even' ) as $style}                                        
                                {set $item_class_2 = array()
                                     $level_2_items_count = $level_2_items|count()}
                                {if $current_node_in_path_2|eq($item2.node_id)}
                                    {set $item_class_2 = array("selected")}
                                {/if}
                                {if $key|eq(0)}
                                    {set $item_class_2 = $item_class_2|append("subfirstli")}
                                {/if}
                                {if $level_2_items_count|eq( $key|inc )}
                                    {set $item_class_2 = $item_class_2|append("sublastli")}
                                {/if}
                                {if $item2.node_id|eq( $current_node_id )}
                                    {set $item_class_2 = $item_class_2|append("current")}
                                {/if}
                                {set $item_class_2 = $item_class_2|append($item2.name|slugize())}
                                <li class="{$style}">
                                    <a title="{if is_set($item2.data_map.abstract)}{if $item2|has_abstract()}{$item2|abstract()|openpa_shorten()}{/if}{else}link a {$item2.name|wash()}{/if}" class="{$item2.name|slugize()}" href={if eq( $ui_context, 'browse' )}{concat("content/browse/", $item2.node_id)|ezurl}{else}{if $item2.node_id|eq($item2.main_node_id)}{$item2.url_alias|ezurl}{else}{if $item2.class_identifier|eq('area_tematica')}{$item2.object.main_node.url_alias|ezurl}{else}{$item2.url_alias|ezurl}{/if}{/if}{/if}{if $pagedata.is_edit} onclick="return false;"{/if}>
                                        {if is_set( $item2.data_map.name )}
                                        {attribute_view_gui attribute=$item2.data_map.name}
                                        {else}
                                        {$item2.name|wash()}
                                        {/if}
                                    </a>
                                </li>
                            {/foreach}
                        </ul>
                    {/if}				
                </div>

          {/foreach}
    {/if}
    {undef $level_2_items $root_node $top_menu_items $item_class $top_menu_items_count $current_node_in_path}
