<meta name="google-site-verification" content="9YzWApsIRq0XSng8VKaUzYQI__x-nXT3OhRWH-tW5Us" />
{default enable_help=true() enable_link=true()}
{if is_set($module_result.content_info.persistent_variable.site_title)}
    {set scope=root site_title=$module_result.content_info.persistent_variable.site_title}
{else}
    {let name=Path
         path=$module_result.path
         reverse_path=array()}
    {if is_set($pagedata.path_array)}
        {set path=$pagedata.path_array}
    {elseif is_set($module_result.title_path)}
        {set path=$module_result.title_path}
    {/if}
    {section loop=$:path}
        {set reverse_path=$:reverse_path|array_prepend($:item)}
    {/section}
    {set-block scope=root variable=site_title}
        {section loop=$Path:reverse_path}{$:item.text|wash}{delimiter} / {/delimiter}{/section} - {$site.title|wash}
    {/set-block}
    {/let}
{/if}

{if and(is_set($#Header:extra_data),is_array($#Header:extra_data))}
      {section name=ExtraData loop=$#Header:extra_data}
          {$:item}
      {/section}
{/if}

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<meta http-equiv="Content-Style-Type" content="text/css" />
    {* check if we need a http-equiv refresh *}
{if $site.redirect}
<meta http-equiv="Refresh" content="{$site.redirect.timer}; URL={$site.redirect.location}" />
{/if}

{foreach $site.http_equiv as $key => $item}
<meta name="{$key|wash}" content="{$item|wash}" />
{/foreach}

{foreach $site.meta as $key => $item}
{if is_set( $module_result.content_info.persistent_variable[$key] )}
<meta name="{$key|wash}" content="{$module_result.content_info.persistent_variable[$key]|wash}" />
{else}
<meta name="{$key|wash}" content="{$item|wash}" />
{/if}
{/foreach}

<meta name="MSSmartTagsPreventParsing" content="TRUE" />
<meta name="generator" content="eZ Publish with OpenContent OpenPA Extension" />

<title>{$site_title}</title>

{if $enable_link}
    {include uri="design:link.tpl" enable_help=$enable_help enable_link=$enable_link}
{/if}

{/default}