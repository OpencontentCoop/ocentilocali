{*def $extra_info = 'extra_info'
     $left_menu = ezini('SelectedMenu', 'LeftMenu', 'menu.ini')
     $openpa = object_handler($node)
     $homepage = fetch('openpa', 'homepage')
     $current_user = fetch('user', 'current_user')
     $user_hash = concat( $current_user.role_id_list|implode( ',' ), ',', $current_user.limited_assignment_value_list|implode( ',' ) )*}
{* calcolo del path_array *}
{def $parents = $node.path
     $path = array()
     $page_root_depth = cond(ezini_hasvariable('SiteSettings', 'RootNodeDepth'), ezini('SiteSettings', 'RootNodeDepth')|sub(1), 0)}
{foreach $parents as $index => $parent}
    {if $index|ge($page_root_depth)}
        {set $path = $path|append(hash(
        'text', $parent.name,
        'url', concat('/content/view/full/', $parent.node_id),
        'url_alias', $parent.url_alias,
        'node_id', $parent.node_id
        ))}
    {/if}
{/foreach}
{set $path = $path|append(hash(
    'text', $node.name,
    'url', concat('/content/view/full/', $node.node_id),
    'url_alias', $node.url_alias,
    'node_id', $node.node_id
))}
{def $pagedata = hash('path_array', $path)}

{* calcolo dell'extrainfo *}
{if or( openpaini( 'ExtraMenu', 'NascondiNeiNodi', array( 0 ) )|contains($node.node_id),
        openpaini( 'ExtraMenu', 'NascondiNelleClassi', array( 0 ) )|contains($node.class_identifier),
        openpaini( 'ExtraMenu', 'Nascondi', false() ) )}
    {set $extra_info = false()}

{elseif $node.parent.class_identifier|eq( 'newsletter' )}
    {set $extra_info = 'extra_info_newsletter'}

{elseif $node.parent.class_identifier|eq( 'pagina_trasparenza' )}
    {set $extra_info = false()}
{/if}

{* calcolo del left menu *}
{if or( openpaini( 'SideMenu', 'NascondiNeiNodi', array( 0 ) )|contains($node.node_id),
        openpaini( 'SideMenu', 'NascondiNelleClassi', array( 0 ) )|contains($node.class_identifier) )}
    {set $left_menu = false()}
{/if}

{set-block variable=$extra_info_content}
    {if $extra_info}
        {include name="extra-menu" uri='design:page_extramenu.tpl' extra_menu=$extra_info node=$node}
    {/if}
{/set-block}
{if has_html_content($extra_info_content)|not()}
    {set $extra_info = false()}
{/if}

{set-block variable=$left_menu_content}
    {if $left_menu}
        {include name="left-menu" uri='design:page_leftmenu.tpl' left_menu=$left_menu pagedata=$pagedata requested_uri_string=$node.url_alias ui_context='view' user_hash=$user_hash}
    {/if}
{/set-block}
{if has_html_content($left_menu_content)|not()}
    {set $left_menu = false()}
{/if}

{ezpagedata_set( 'extra_menu', $extra_info )}
{ezpagedata_set( 'left_menu',  $left_menu  )}

{if $homepage.node_id|eq($node.node_id)}
    {ezpagedata_set('is_homepage', true())}
{/if}
{if $openpa.control_area_tematica.is_area_tematica}
    {ezpagedata_set('is_area_tematica', $openpa.control_area_tematica.area_tematica.contentobject_id)}
    {ezpagedata_set('area_tematica_node_id', $openpa.control_area_tematica.area_tematica.node_id)}
    {ezpagedata_set('area_tematica_path_array', $openpa.control_area_tematica.area_tematica.path_array)}
    {ezpagedata_set('area_tematica_cover_image', $openpa.control_area_tematica.area_tematica_cover_image)}
    {ezpagedata_set('area_tematica_image', $openpa.control_area_tematica.area_tematica_image)}
{/if}

{ezpagedata_set('has_container',  true())}
{ezpagedata_set('current_main_style', $openpa.content_pagestyle.main_style)}

<div id="columns-position" class="width-layout {$node.class_identifier}">
    <div class="columns-ml"><div class="columns-mr"><div class="columns-mc">
    <div class="columns-content">
    <div id="columns" class="float-break">

        {if $left_menu}
            {$left_menu_content}
        {/if}
        {include uri='design:page_searchbox.tpl'}
        <div id="main-position">
            <div id="main" class="float-break">
                <div class="overflow-fix">