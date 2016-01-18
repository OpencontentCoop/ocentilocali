
    <title>Portale del territorio</title>

    {section show=and(is_set($#Header:extra_data),is_array($#Header:extra_data))}
      {section name=ExtraData loop=$#Header:extra_data}
      {$:item}
      {/section}
    {/section}

    {foreach $site.http_equiv as $key => $value}
    {if and( $disable_meta_language, $key|eq('Content-language') )}{continue}{/if}
    <meta http-equiv="{$key|wash}" content="{$value|wash}" />

    {/foreach}

    {foreach $site.meta as $key => $value}
    <meta name="{$key|wash}" content="{$value|wash}" />

    {/foreach}

    <meta name="generator" content="eZ Publish" />

