{def $inimenu = openpaini( 'SideMenu', 'IdentificatoriMenu', array() )}
{def $node_id = $view_parameters.node_id
	$current_node_id = $view_parameters.current_node_id
	$current_menu = $view_parameters.current_menu
	$ui_context = $view_parameters.ui_context
	$is_area_tematica = $view_parameters.is_area_tematica
	$parent_node = fetch(content, node, hash(node_id, $current_node_id))
	$current_user = fetch( 'user', 'current_user' )
    $resolve_link = openpaini( 'SideMenu', 'EsponiLink', false() )}

{if is_unset($pagedesign)}
    {def $pagedata   = ezpagedata()
         $pagedesign = $pagedata.template_look}
{/if}

{cache-block keys=array( $current_node_id, $current_user.contentobject_id  )}

{def 	$left_menu_depth=$current_menu
		$root_node=fetch( 'content', 'node', hash( 'node_id', $node_id ) )}

{if $root_node.class_identifier|eq('trasparenza')}
  {set $inimenu = array( 'pagina_trasparenza' )}
{/if}

{def	$url_alias=$root_node.url_alias		
		$node=fetch( 'content', 'node', hash( 'node_id', $current_node_id ) )		
		$left_menu_root_url = cond( $url_alias, $url_alias, $requested_uri_string )
		$left_menu_items = fetch( 'content', 'list', hash( 'parent_node_id', $root_node.node_id,
                                                            'sort_by', $root_node.sort_array,
                                                            'data_map_load', false(),
                                                            'class_filter_type', 'include',
                                                            'class_filter_array', $inimenu ) )
		$left_menu_items_count = $left_menu_items|count()
		$li_class = array()
		$li_class3 = array()
		$li_class4 = array()
		$a_class = array()
		$a_class3 = array()
		$a_class4 = array()}
{if $is_area_tematica}
	{set $left_menu_depth = inc($left_menu_depth)}
{/if}

    {if $left_menu_items_count}
        {foreach $left_menu_items as $key => $item}
        {if openpaini( 'SideMenu', 'NascondiNodi', array() )|contains( $item.node_id )|not()}
            {def $sub_menu_items = fetch( 'content', 'list', hash( 'parent_node_id', $item.node_id, 'sort_by', $item.sort_array, 'data_map_load', false(),
																   'class_filter_type', 'include', 'class_filter_array', $inimenu ) )
                 $sub_menu_items_count = $sub_menu_items|count}
			
			{set $a_class = cond($node.path_array|contains($item.node_id), array("selected"), array())
                 $li_class = cond( $key|eq(0), array("firstli"), array() )}

            {if $left_menu_items_count|eq( $key|inc )}
                {set $li_class = $li_class|append("lastli")}
            {/if}
            {if $item.node_id|eq( $current_node_id )}
                {set $a_class = $a_class|append("current")}
            {/if}
            
			<li{if $li_class} class="{$li_class|implode(" ")}"{/if}>
				<div class="second_level_menu">
					<span class="handler {if $a_class}{$a_class|implode(" ")}{/if}{if $sub_menu_items_count} activable{/if}"></span>
                    {if and( $resolve_link, eq( $item.class_identifier, 'link') )}
                        <a {if eq( $ui_context, 'browse' )}href={concat("content/browse/", $item.node_id)|ezurl}{else}href={$item.data_map.location.content|ezurl}{if and( is_set( $item.data_map.open_in_new_window ), $item.data_map.open_in_new_window.data_int )} target="_blank"{/if}{/if}{if $a_class} class="{$a_class|implode(" ")}"{/if} title="{$item.data_map.location.data_text|wash}" class="menu-item-link" rel={$item.url_alias|ezurl}>
                    {else}
                        <a href={if eq( $ui_context, 'browse' )}{concat("content/browse/", $item.node_id)|ezurl}{else}{if $item.node_id|eq($item.main_node_id)}{$item.url_alias|ezurl}{else}{if $item.class_identifier|eq('area_tematica')}{$item.object.main_node.url_alias|ezurl}{else}{$item.url_alias|ezurl}{/if}{/if}{/if}{if $a_class} class="{$a_class|implode(" ")}"{/if}>
                    {/if}
                        <span>{$item.name|wash()}</span>
					</a>
				</div>
            
                {if $sub_menu_items_count}
                <ul class="submenu-list">
                    {foreach $sub_menu_items as $subkey => $subitem}
                    {if openpaini( 'SideMenu', 'NascondiNodi', array() )|contains( $subitem.node_id )|not()}
						{def $sub_menu_items3 = fetch( 'content', 'list', hash( 'parent_node_id', $subitem.node_id, 'sort_by', $subitem.sort_array, 'data_map_load', false(),
																				'class_filter_type', 'include', 'class_filter_array', $inimenu ) )
						$sub_menu_items_count3 = $sub_menu_items3|count}
                       	{set $a_class = cond($node.path_array|contains($subitem.node_id), array("selected"), array())  $li_class = cond( $subkey|eq(0), array("firstli"), array() )}
                    	{if $sub_menu_items_count|eq( $subkey|inc )} {set $li_class = $li_class|append("lastli")} {/if}
                    	{if $subitem.node_id|eq( $current_node_id )} {set $a_class = $a_class|append("current")} {/if}
                    	
						<li{if $li_class} class="{$li_class|implode(" ")}"{/if}>
							<div class="third_level_menu">
								<span class="handler {if $a_class}{$a_class|implode(" ")}{/if}{if $sub_menu_items_count3} activable{/if}"></span>
								{if and( $resolve_link, eq( $subitem.class_identifier, 'link') )}
                                    <a {if eq( $ui_context, 'browse' )}href={concat("content/browse/", $subitem.node_id)|ezurl}{else}href={$subitem.data_map.location.content|ezurl}{if and( is_set( $subitem.data_map.open_in_new_window ), $subitem.data_map.open_in_new_window.data_int )} target="_blank"{/if}{/if}{if $a_class} class="{$a_class|implode(" ")}"{/if} title="{$subitem.data_map.location.data_text|wash}" class="menu-item-link" rel={$subitem.url_alias|ezurl}>
                                {else}
                                    <a href={if eq( $ui_context, 'browse' )}{concat("content/browse/", $subitem.node_id)|ezurl}{else}{if $subitem.node_id|eq($subitem.main_node_id)}{$subitem.url_alias|ezurl}{else}{if $subitem.class_identifier|eq('area_tematica')}{$subitem.object.main_node.url_alias|ezurl}{else}{$subitem.url_alias|ezurl}{/if}{/if}{/if}{if $pagedata.is_edit} onclick="return false;"{/if}{if $a_class} class="{$a_class|implode(" ")}"{/if}>
                                {/if}
									<span>{$subitem.name|wash()}</span>
								</a>
							</div>
					{*  start terzo livello *}               	
							{if $sub_menu_items_count3} 
							<ul class="submenu-list-3">
								{foreach $sub_menu_items3 as $subkey3 => $subitem3}
                                {if openpaini( 'SideMenu', 'NascondiNodi', array() )|contains( $subitem3.node_id )|not()}
									{def $sub_menu_items4 = fetch( 'content', 'list', hash( 'parent_node_id', $subitem3.node_id, 'sort_by', $subitem3.sort_array, 'data_map_load', false(),
																		'class_filter_type', 'include', 'class_filter_array', $inimenu ) )
									 $sub_menu_items_count4 = $sub_menu_items4|count}
									{set $a_class3 = cond($node.path_array|contains($subitem3.node_id), array("selected"), array())  $li_class3 = cond( $subkey3|eq(0), array("firstli"), array() )}
									{if $sub_menu_items_count3|eq( $subkey|inc )} {set $li_class3 = $li_class3|append("lastli")} {/if}
									{if $subitem3.node_id|eq( $current_node_id )} {set $a_class3 = $a_class3|append("current")}{/if}
										
										<li{if $li_class3} class="{$li_class3|implode(" ")}"{/if}>
											<div class="fourth_level_menu">
												<span class="handler {if $a_class3}{$a_class3|implode(" ")}{/if}{if $sub_menu_items_count4} activable{/if}"></span>
                                                {if and( $resolve_link, eq( $subitem3.class_identifier, 'link') )}
                                                    <a {if eq( $ui_context, 'browse' )}href={concat("content/browse/", $subitem3.node_id)|ezurl}{else}href={$subitem3.data_map.location.content|ezurl}{if and( is_set( $subitem3.data_map.open_in_new_window ), $subitem3.data_map.open_in_new_window.data_int )} target="_blank"{/if}{/if}{if $a_class} class="{$a_class|implode(" ")}"{/if} title="{$subitem3.data_map.location.data_text|wash}" class="menu-item-link" rel={$subitem3.url_alias|ezurl}>
                                                {else}
                                                    <a href={if eq( $ui_context, 'browse' )}{concat("content/browse/", $subitem3.node_id)|ezurl}{else}{if $subitem3.node_id|eq($subitem3.main_node_id)}{$subitem3.url_alias|ezurl}{else}{if $subitem3.class_identifier|eq('area_tematica')}{$subitem3.object.main_node.url_alias|ezurl}{else}{$subitem3.url_alias|ezurl}{/if}{/if}{/if}{if $pagedata.is_edit} onclick="return false;"{/if}{if $a_class3} class="{$a_class3|implode(" ")}"{/if}>
                                                {/if}
													<span>{$subitem3.name|wash()}</span>
												</a>
											</div>
					{*  start quarto livello   *}						
											{if $sub_menu_items_count4}
											<ul class="submenu-list-4">
												{foreach $sub_menu_items4 as $subkey4 => $subitem4}
                                                {if openpaini( 'SideMenu', 'NascondiNodi', array() )|contains( $subitem4.node_id )|not()}
													{set $a_class4 = cond($node.path_array|contains($subitem4.node_id), array("selected"), array())  $li_class4 = cond( $subkey4|eq(0), array("firstli"), array() )}
													{if $sub_menu_items_count4|eq( $subkey|inc )} {set $li_class4 = $li_class4|append("lastli")} {/if}
													{if $subitem4.node_id|eq( $current_node_id )} {set $a_class4 = $a_class4|append("current")}{/if}
													{if $subitem4.node_id|eq( $parent_node.parent_node_id )} {set $a_class4 = $a_class4|append("selected")}{/if}
													
													<li{if $li_class4} class="{$li_class4|implode(" ")}"{/if}>
														<div class="fifth_level_menu">
															{if and( $resolve_link, eq( $subitem4.class_identifier, 'link') )}
                                                                <a {if eq( $ui_context, 'browse' )}href={concat("content/browse/", $subitem4.node_id)|ezurl}{else}href={$subitem4.data_map.location.content|ezurl}{if and( is_set( $subitem4.data_map.open_in_new_window ), $subitem4.data_map.open_in_new_window.data_int )} target="_blank"{/if}{/if}{if $a_class} class="{$a_class|implode(" ")}"{/if} title="{$subitem4.data_map.location.data_text|wash}" class="menu-item-link" rel={$subitem4.url_alias|ezurl}>
                                                            {else}
                                                                <a href={if eq( $ui_context, 'browse' )}{concat("content/browse/", $subitem4.node_id)|ezurl}{else}{if $subitem4.node_id|eq($subitem4.main_node_id)}{$subitem4.url_alias|ezurl}{else}{if $subitem4.class_identifier|eq('area_tematica')}{$subitem4.object.main_node.url_alias|ezurl}{else}{$subitem4.url_alias|ezurl}{/if}{/if}{/if}{if $pagedata.is_edit} onclick="return false;"{/if}{if $a_class4} class="{$a_class4|implode(" ")}"{/if}>
                                                            {/if}
																<span>{$subitem4.name|wash()}</span>
															</a>
														</div>
													</li>
												{/if}	
												{/foreach}
											</ul>
											{/if}
											{undef $sub_menu_items4 $sub_menu_items_count4}
					{*  end quarto livello   *}
										</li>
								{/if}
                                {/foreach}
							</ul>
							{/if}
							{undef $sub_menu_items3 $sub_menu_items_count3}
					{*  end terzo livello   *}
						</li>
                    {/if}
                    {/foreach}
                </ul>
                {/if}
				{undef $sub_menu_items $sub_menu_items_count}
            </li>
        {/if}
        {/foreach}
    {/if}
    {undef $root_node $left_menu_items $left_menu_items_count $a_class $li_class}


{undef $left_menu_root_url $left_menu_depth $inimenu}
{/cache-block}