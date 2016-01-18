{*
	OGGETTI INVERSAMENTE CORRELATI
	node	nodo a cui si riferisce
	title	titolo del blocco
	

*}



{def $objects=fetch( 'content', 'reverse_related_objects', 
              hash( 'object_id',$node.object.id, 
                'sort_by',  array( 'name', true() ),
                'group_by_attribute', true(),
                'all_relations', true() ) ) 
     $objects_count=$objects|count()
}
	
{*

{def $style='col-odd'}
{if $objects_count|gt(0)}
	{if $objects_count|lt(100)}
		<div class="oggetti-correlati oggetti-inv-correlati{if $objects|count()|not()} nocontent{/if}">
			<div class="border-header border-box box-trans-blue box-allegati-header">
				<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
				<div class="border-ml"><div class="border-mr"><div class="border-mc">
				<div class="border-content">
					<h2>{$title}</h2>
				</div>
				</div></div></div>
			</div>
			<div class="border-body border-box box-violet box-allegati-content">
				<div class="border-ml"><div class="border-mr"><div class="border-mc">
				<div class="border-content">
		            {foreach $objects as $_object}   
                    {foreach $_object as $object}
					{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
						<div class="{$style} col float-break col-notitle">
						<div class="col-content"><div class="col-content-design">
							
							<img class="image-class_identifier" src={concat('icons/crystal/64x64/mimetypes/',$object.main_node.class_identifier,'.png')|ezimage()} alt="{$object.class_identifier}" title="{$object.class_identifier}" />
							{if $is_area_tematica}
								{def    $BNode_id=module_params().parameters.NodeID
                							$local_link=fetch(content,node,hash(node_id,$BNode_id))}
								<a {if is_set($object.data_map.abstract)}title="{$object.data_map.abstract.content.output.output_text|explode("<br />")|implode(" ")|strip_tags()|trim()}"{/if} href={concat($local_link.url_alias, '/(reference)/',$object.main_node_id)|ezurl()}>{$object.name}</a>
							{else}
							<a {if is_set($object.data_map.abstract)}title="{$object.data_map.abstract.content.output.output_text|explode("<br />")|implode(" ")|strip_tags()|trim()}"{/if} href={$object.main_node.url_alias|ezurl()}>{$object.name}</a>
							{/if}
						</div></div>
						</div>
                		{/foreach}
                        {/foreach}
				</div>
				</div></div></div>
				<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
			</div>
		</div>
	


*}
{if $objects_count|gt(0)}

<div class="border-box box-trans-blue box-tabs-header tabs" style="padding:0 20px;">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc">
<div class="border-content">	

<h2>{$title}</h2>

{ezscript_require(array( 'ezjsc::jquery', 'ui-widgets.js' ) )}

<script type="text/javascript">
{literal}
$(function() {
	$("#zone-id-{/literal}{$node.node_id}{literal}").tabs();
});
{/literal}
</script>


<div class="block-type-lista block-lista_tab">

	<div class="ui-tabs"  id="zone-id-{$node.node_id}">	

        <ul class="ui-tabs-nav">							 
            {foreach $objects as $index => $_object}
            <li class="{$_object[0].class_identifier} {if $index|eq(0)}ui-state-active{else}ui-state-default{/if}">											
                <a href="#panel-{$_object[0].class_identifier}"><span class="panel-{$_object[0].class_identifier}">{$_object[0].class_name|wash()}</span></a>					
            </li>
            {/foreach}
        </ul>
    	
			{foreach $objects as $index => $_object}   
            
			<div id="panel-{$_object[0].class_identifier}">
			
				<div class="border-content" style="background:#fff;">
					
                    {foreach $_object as $object}
                    
                    <div class="col float-break col-notitle">
                    <div class="col-content"><div class="col-content-design">
                        {*<img class="image-class_identifier" src="/share/icons/crystal/24x24/mimetypes/{$object.main_node.class_identifier}.png" alt="{$object.class_identifier}" title="{$node.object.class_identifier}" />*}
                        <img class="image-class_identifier" src={concat('icons/crystal/64x64/mimetypes/',$object.main_node.class_identifier,'.png')|ezimage()} alt="{$object.class_identifier}" title="{$object.class_identifier}" />
                        <a href={$object.main_node.url_alias|ezurl()}>{$object.name}</a>
                        {if is_set($object.data_map.abstract)}
                        <small>{attribute_view_gui attribute=$object.data_map.abstract}</small>
                        {/if} 
					</div></div>
                    </div>

                    {/foreach}
                    
				</div>		
			
			</div>
				
			
            {/foreach}
	
	</div>

</div>

</div>
</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>		

{/if}
