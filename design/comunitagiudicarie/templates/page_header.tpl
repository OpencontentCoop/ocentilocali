<div id="header-position">
<div id="header" class="float-break width-layout">
  
    <h1>        
        {def $siteName = cond( $ente, $ente.name|wash(), ezini('SiteSettings','SiteName')|wash() )}
        <a href={cond( $ente, $ente.url, '/' )|ezurl} title="{$siteName}"{$siteName|autofont( 'logo' )}>
            {if and( $ente, is_set( $ente.data_map.stemma ), $ente.data_map.stemma.has_content )}
                {attribute_view_gui attribute=$ente.data_map.stemma image_class=carouselthumbnail}
            {/if}            
        </a>
    </h1>
        
    <p class="hide"><a href="#main">{'Skip to main content'|i18n('design/ezflow/pagelayout')}</a></p>
  
	{if $is_login_page|not()}
        {include uri='design:page_header_links.tpl'}
    {/if}
  
    {if and( $pagedata.top_menu, $is_login_page|not() )}
        {include uri='design:page_topmenu.tpl'}
    {/if}
  
</div>
</div>

<div id="page-content-position">
{def $page_title = false()}
{if is_set( $pagedata.persistent_variable.page_title )}
    {set $page_title = $pagedata.persistent_variable.page_title}
{elseif is_comune()}
    {set $page_title = is_comune().name|wash()}    
{/if}

{if $page_title}<div id="page-title" class="width-layout">{$page_title}</div>{/if}
<div id="page-content" class="width-layout">