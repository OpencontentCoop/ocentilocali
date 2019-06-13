<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="it" lang="it">
<head>

    {if is_set( $extra_cache_key )|not}
    {def $extra_cache_key = ''}
    {/if}

    {if openpacontext().is_area_tematica}
    {set $extra_cache_key = concat($extra_cache_key, 'areatematica_', openpacontext().is_area_tematica)}
    {/if}

    {if and( is_set( openpacontext().extra_template_list ), openpacontext().extra_template_list|count() )}
    {set $extra_cache_key = concat($extra_cache_key, openpacontext().extra_template_list|implode('-'))}
    {/if}

    {debug-accumulator id=page_head_style name=page_head_style}
    {include uri='design:page_head_style.tpl'}
    <!--[if lte IE 8]> <style type="text/css"> @import url({'stylesheets/iefonts.css'|ezdesign()}); </style> <![endif]-->
    {/debug-accumulator}

    {debug-accumulator id=page_head_script name=page_head_script}
    {include uri='design:page_head_script.tpl'}
    {/debug-accumulator}

    {include uri='design:page_head.tpl'}
    {include uri='design:page_head_google_tag_manager.tpl'}
    {include uri='design:page_head_google-site-verification.tpl'}
    {no_index_if_needed()}

</head>

<body class="no-js">
<script type="text/javascript">
//<![CDATA[
var CurrentUserIsLoggedIn = {cond(fetch('user','current_user').is_logged_in, 'true', 'false')};
var UiContext = "{$ui_context}";
var UriPrefix = {'/'|ezurl()};
var PathArray = [{if is_set( openpacontext().path_array[0].node_id )}{foreach openpacontext().path_array|reverse as $path}{$path.node_id}{delimiter},{/delimiter}{/foreach}{/if}];
(function(){ldelim}var c = document.body.className;c = c.replace(/no-js/, 'js');document.body.className = c;{rdelim})();
var ModuleResultUri = "{$module_result.uri|wash()}";
//]]>
</script>
{include uri='design:page_body_google_tag_manager.tpl'}

{include uri='design:page_browser_alert.tpl'}

{debug-accumulator id=entelocale_background name=entelocale_background}
<div id="page" class="{openpacontext().css_classes} {openpacontext().current_main_style}"{entelocale_background()}>
    {/debug-accumulator}

    {cache-block expiry=86400 ignore_content_expiry keys=array( $access_type.name, openpacontext().top_menu_cache_key, $extra_cache_key )}
    {def $ente = fetch(openpa, homepage)
         $pagedata = openpapagedata()
         $current_node_id  = $pagedata.node_id}

    {if and( is_set( openpacontext().extra_template_list ), openpacontext().extra_template_list|count() )}
        {foreach openpacontext().extra_template_list as $extra_template}
            {include uri=concat('design:extra/', $extra_template)}
        {/foreach}
    {/if}

    <div id="header-position">
        <div id="header" class="float-break width-layout">
            {include uri='design:page_header_logo.tpl'}
            <p class="hide"><a href="#main">{'Skip to main content'|i18n('design/ezflow/pagelayout')}</a></p>
            {if openpacontext().is_login_page|not()}
                {include uri='design:page_header_links.tpl'}
            {/if}
            {if and( openpacontext().top_menu, openpacontext().is_login_page|not() )}
                {include uri='design:page_topmenu.tpl'}
            {/if}
        </div>
    </div>
    {/cache-block}

    <div id="page-content-position">

        {if is_set( openpacontext().page_title )}
            <div id="page-title" class="width-layout">{openpacontext().page_title}</div>
        {/if}

        <div id="page-content" class="width-layout">

            {debug-accumulator id=page_toolbar name=page_toolbar}
            {include uri='design:page_toolbar.tpl'}
            {/debug-accumulator}

            {if openpacontext().show_breadcrumb}
            {debug-accumulator id=page_toppath name=page_toppath}
            {include uri='design:page_toppath.tpl'}
            {/debug-accumulator}
            {/if}

            {include uri='design:page_mainarea.tpl'}

        </div>
    </div>

    {cache-block expiry=86400 ignore_content_expiry keys=array( $access_type.name )}
    {if is_set($ente)|not()}
    {def $ente = fetch(openpa, homepage)
         $pagedata = openpapagedata()
         $current_node_id  = $pagedata.node_id}
    {/if}
        {include uri='design:page_footer.tpl'}
    {/cache-block}

</div>

{include uri='design:page_footer_script.tpl'}


<!--DEBUG_REPORT-->
</body>
</html>
