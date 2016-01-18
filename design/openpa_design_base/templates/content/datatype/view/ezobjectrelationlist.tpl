{def $related_objects = array()
     $wrong_relations = array()}
{foreach $attribute.content.relation_list as $related}
    {if $related.in_trash|not()}
        {def $valid_object = fetch( content, object, hash( object_id, $related.contentobject_id ) )|is_in_subsite()}
        {if $valid_object}
            {set $related_objects = $related_objects|append( $valid_object )}
        {else}
            {set $wrong_relations = $wrong_relations|append( $related.contentobject_id )}
        {/if}
        {undef $valid_object}
    {/if}
{/foreach}

{if is_set($href)}
	
    {if $href|eq('nolink')}
        {foreach $related_objects as $object}
            {if $object.class_identifier|eq('tipo_struttura')}
                {def $tipi_stuttura_invisibili = openpaini( 'GestioneAttributi', 'tipi_stuttura_invisibili', array())}
                {if $tipi_stuttura_invisibili|contains($object.data_map.tipo_struttura.content)|not()}
                    {content_view_gui view=embed_nolink content_object=$object}
                {/if}
            {else}
                {content_view_gui view=embed_nolink content_object=$object}
            {/if}			    			
                {delimiter} <span class="previous">-</span> {/delimiter}		
        {/foreach}
	
    {elseif $href|eq('noedit')}
		{foreach $related_objects as $object}
			{content_view_gui view=embed content_object=$object}
			{delimiter}<br />{/delimiter}
		{/foreach}

	{elseif $href|eq('estesa')}
        {foreach $related_objects as $object}
			{content_view_gui view=line content_object=$object}			
		{/foreach}
		
	{/if}

{else}

	{foreach $related_objects as $object}
        {content_view_gui view=embed content_object=$object}
        {delimiter} <span class="previous">-</span> {/delimiter}
    {/foreach}

{/if}