{if and( is_set( $DesignKeys:used.url_alias ), $DesignKeys:used.url_alias|count|ge(1) )}
	{def $avail_translation = language_switcher( $DesignKeys:used.url_alias )}
{else}
	{def $avail_translation = language_switcher( $site.uri.original_uri)}
{/if}

{if count( $avail_translation )|gt( 1 )}
{def $key = 1}
{foreach $avail_translation as $siteaccess => $lang}
	{def $_class = 'lang'}
    {if $siteaccess|eq($access_type.name)}
        {set $_class = concat( $_class, ' current_siteaccess' )}
    {/if}
    {if count( $avail_translation )|eq( $key )}
        {set $_class = concat( $_class, ' lastli' )}
    {/if}
    <li class="{$_class}"><a href={$lang.url|ezurl}>{$lang.text|wash}</a></li>
    {set $key = $key|inc()}
    {undef $_class}
{/foreach}
{undef $key}
{/if}
