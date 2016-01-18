{let class_content=$attribute.class_content
     class_list=fetch( class, list, hash( class_filter, $class_content.class_constraint_list ) )
     can_create=true()
     current_user = fetch( 'user', 'current_user' )
     servizio_utente = fetch( 'content', 'related_objects',  hash( 'object_id', $current_user.contentobject_id, 'attribute_identifier', openpaini( 'ControlloUtenti', 'user_servizio_attribute_ID', 909 ),'all_relations', false() ))
     ufficio_utente = fetch( 'content', 'related_objects',  hash( 'object_id', $current_user.contentobject_id, 'attribute_identifier', openpaini( 'ControlloUtenti', 'user_ufficio_attribute_ID', 911 ),'all_relations', false() ))
     new_object_initial_node_placement=false()
     browse_object_start_node=false()}


{default attribute_base=ContentObjectAttribute}

{def $trasparenza_node = 0}
{def $trasparenza_search = fetch( 'ezfind','search', hash( 'subtree_array', array( ezini( 'NodeSettings', 'RootNode', 'content.ini' ) ), 'class_id', array( 'trasparenza' ) ) )}
{if $trasparenza_search.SearchCount|gt(0)}
  {set $trasparenza_node = $trasparenza_search.SearchResult[0].node_id}
{/if}
{undef $trasparenza_search}

{def $nodesList= fetch( content, tree,
							hash( parent_node_id, ezini( 'NodeSettings', 'RootNode', 'content.ini' ),
								  class_filter_type,'include',
								  class_filter_array, array( 'politico' ),
								  sort_by, array( 'name',true() ),
								  main_node_only, true() ) )}

{foreach $nodesList as $node}
	<label>
	<input
		   type="checkbox"
		   name="{$attribute_base}_data_object_relation_list_{$attribute.id}[{$node.node_id}]"
		   value="{$node.contentobject_id}"
		  {if ne( count( $attribute.content.relation_list ), 0)}
		  {foreach $attribute.content.relation_list as $item}
			   {if eq( $item.contentobject_id, $node.contentobject_id )}
					  checked="checked"
					  {break}
			   {/if}
		  {/foreach}
		  {/if}
	/>
	{if $node.path_array|contains( $trasparenza_node )}<span style="color: #ccc">{/if}
	{$node.name|wash}
	{if $node.path_array|contains( trasparenza_node )}</span>{/if}
	</label>	
{/foreach}

{def $dirigenti = fetch( openpa, dirigenti )}
{if count( $dirigenti )|gt(0)}
	<label>Dipendenti con ruolo dirigenziale:</label>
	{foreach $dirigenti as $dirigente}
		<input type="checkbox" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[{$dirigente.node_id}]" value="{$dirigente.contentobject_id}"
		{if ne( count( $attribute.content.relation_list ), 0)}
		{foreach $attribute.content.relation_list as $item}
			 {if eq( $item.contentobject_id, $dirigente.contentobject_id )}
					checked="checked"
					{break}
			 {/if}
		{/foreach}
		{/if}
		/>
		{$dirigente.name|wash} <br/>
	{/foreach}
{/if}

{undef $nodesList $trasparenza_node}
{/default}
{/let}
