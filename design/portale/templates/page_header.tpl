<div id="header-position">
<div id="header" class="float-break width-layout">
  
        
    <p class="hide"><a href="#main">{'Skip to main content'|i18n('design/ezflow/pagelayout')}</a></p>
  
    {include uri='design:page_header_links.tpl'}
  
    
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