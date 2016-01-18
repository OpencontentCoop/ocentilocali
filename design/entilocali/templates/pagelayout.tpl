<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="it">
<head>
{set $current_user = fetch( 'user', 'current_user' )}
{def $user_hash = concat( $current_user.role_id_list|implode( ',' ), ',', $current_user.limited_assignment_value_list|implode( ',' ) )
     $is_login_page = cond( and( module_params()['module_name']|eq( 'user' ), module_params()['function_name']|eq( 'login' ) ), true(), false() ) }


{if is_set( $extra_cache_key )|not}
    {def $extra_cache_key = ''}
{/if}

{def $browser          = checkbrowser('checkbrowser')
     $cookies          = check_and_set_cookies()
     $pagedata         = ezpagedata()
     $pagestyle        = $pagedata.css_classes
     $locales          = fetch( 'content', 'translation_list' )
     $pagedesign       = $pagedata.template_look
     $current_node_id  = $pagedata.node_id
     $main_style       = get_main_style()
     $custom_keys      = hash( 'is_login_page', $is_login_page, 'browser', $browser, 'is_area_tematica', is_area_tematica() )|merge( $cookies )
     $ente             = entelocale_node()
     $ente_cache_key   = cond( $ente, $ente.object.modified, '' )
     $background       = entelocale_background()
}

{set scope=global custom_keys=$custom_keys}

{include uri='design:page_head.tpl'}

<!-- Site: {ezsys( 'hostname' )} -->
{if ezsys( 'hostname' )|contains( 'opencontent' )}
<META name="robots" content="NOINDEX,NOFOLLOW" />
{/if}

{include uri='design:page_head_style.tpl'}
<!--[if lte IE 8]> <style type="text/css"> @import url({'stylesheets/iefonts.css'|ezdesign()}); </style> <![endif]-->
{include uri='design:page_head_script.tpl'}

</head>
<body class="no-js">
<script type="text/javascript">{literal}
//<![CDATA[
(function(){var c = document.body.className;
c = c.replace(/no-js/, 'js');
document.body.className = c;
})();
//]]>{/literal}
</script>

{include uri='design:page_browser_alert.tpl'}


{cache-block keys=array( $module_result.uri, $basket_is_empty, $current_user.contentobject_id, $extra_cache_key, $ente_cache_key )}

<div id="page" class="{$pagestyle} {$main_style}"{$background}>

    {if and( is_set( $pagedata.persistent_variable.extra_template_list ), $pagedata.persistent_variable.extra_template_list|count() )}
        {foreach $pagedata.persistent_variable.extra_template_list as $extra_template}
            {include uri=concat('design:extra/', $extra_template)}
        {/foreach}
    {/if}

    {include uri='design:page_header.tpl'}

{/cache-block}    

{cache-block keys=array( $module_result.uri, $basket_is_empty, $current_user.contentobject_id, $extra_cache_key )}
    {if and( $pagedata.website_toolbar, $pagedata.is_edit|not)}
        {include uri='design:page_toolbar.tpl'}
    {/if}

    {if and( $pagedata.show_path, $current_node_id|ne( ezini( 'NodeSettings', 'RootNode', 'content.ini' ) ), $module_result.uri|ne('/content/advancedsearch'), $module_result.uri|ne('/content/search'), $module_result.uri|ne('/content/advancedsearch/'), $module_result.uri|ne('/content/search/') ) }
        {if is_set( $module_result.content_info )}    
            {include uri='design:page_toppath.tpl'}
        {/if}
    {/if}

    <div id="columns-position" class="width-layout {$pagedata.class_identifier}">
    <div class="columns-ml"><div class="columns-mr"><div class="columns-mc">
    <div class="columns-content">
        
        <div id="columns" class="float-break">
    
        {if $pagedata.left_menu}
            {include uri='design:page_leftmenu.tpl'}
        {/if}
    
    {/cache-block}
    
        {include uri='design:page_searchbox.tpl'}
        {include uri='design:page_mainarea.tpl'}
    
    {cache-block keys=array( $module_result.uri, $basket_is_empty, $current_user.contentobject_id, $extra_cache_key, $cookie_dimensione, $cookie_contrasto )}
    
        {if is_unset($pagedesign)}
            {def $pagedata   = ezpagedata()
                 $pagedesign = $pagedata.template_look}
        {/if}
    
        {if and($pagedata.extra_menu, $module_result.content_info)}
            {include uri='design:page_extramenu.tpl'}
        {/if}
        
        </div>
    </div>
    </div></div></div>
    <div class="columns-bl"><div class="columns-br"><div class="columns-bc"></div></div></div>
    </div>

	{if and( $current_node_id|ne( ezini( 'NodeSettings', 'RootNode', 'content.ini' ) ), $pagedata.class_identifier|ne('frontpage'), $pagedata.class_identifier|ne('') ) }
    	{include name=valuation node_id=$current_node_id uri='design:parts/openpa/valuation.tpl'}
	{/if}

{cache-block keys=array( $ente_cache_key )}
    {include uri='design:page_footer.tpl'}
{/cache-block}

</div>

{include uri='design:page_footer_script.tpl'}

{/cache-block}

<!--DEBUG_REPORT-->
</body>
</html>
