<h2 class="hide">Ti trovi in:</h2>
<p>

{if $module_result.content_info.class_identifier|eq('user')}
    {def $localnode=fetch(content, node, hash(node_id,92236))
         $nodo_utente=fetch(content, node, hash(node_id,$module_result.content_info.node_id))
         $paths=$localnode.path}

	{foreach $paths as $path}
		<a href={$path.url_alias|ezurl}>
			{if $path.node_id|eq("2")}
				Home
			{else}
				{$path.name|wash}
			{/if}
  		</a>
  	   <span class="path-separator">&raquo;</span>
	{/foreach}
	<a href={$localnode.url_alias|ezurl}>{$localnode.name|wash}</a>
	<span class="path-separator">&raquo;</span>
	<span class="path-text"> {$nodo_utente.name|wash} </span>
	
{else}    
    {def $index = ezini( 'SiteSettings', 'IndexPage', 'site.ini' )|explode( 'content/view/full/' )|implode('')|explode( '/' )|implode('')}  
  	{foreach openpacontext().path_array as $path}
        {def $do = true()}        
        {if and( $index|ne( 2 ), $path.node_id|eq( 2 ) )}
            {set $do = false()}
        {/if}
        {if $do}
            {if $path.url}
                <a href={cond( is_set( $path.url_alias ), $path.url_alias, $path.url )|ezurl}>
                    {if $path.node_id|eq(ezini( 'NodeSettings', 'RootNode', 'content.ini' ))}
                        Home
                    {else}
                        {$path.text|wash}
                    {/if}
                </a>
                 <span class="path-separator">&raquo;</span>
              {else} 
                <span class="path-text"> {$path.text|wash} </span>	
              {/if}
        {/if}
        {undef $do}
	{/foreach}

{/if}

</p>
