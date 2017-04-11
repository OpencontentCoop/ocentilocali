<div id="logo" class="border-box box-trans-dark">
<div class="border-ml"><div class="border-mr"><div class="border-mc">
<div class="border-content">
    <h1>        
        {def $siteName = cond( $ente, $ente.name|wash(), ezini('SiteSettings','SiteName')|wash() )}
        <a href={cond( $ente, $ente.url, '/' )|ezurl} title="{$siteName}"{$siteName|autofont( 'logo' )}>
            {if and( $ente, is_set( $ente.data_map.stemma ), $ente.data_map.stemma.has_content )}
                {attribute_view_gui attribute=$ente.data_map.stemma image_class=entilocali_only_logo}
            {/if}            
        </a>
    </h1>
</div>
</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>