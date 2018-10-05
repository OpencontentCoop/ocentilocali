{def $extra_info = 'extra_info'
     $left_menu = ezini('SelectedMenu', 'LeftMenu', 'menu.ini')
     $openpa = object_handler($node)
     $homepage = fetch('openpa', 'homepage')
     $current_user = fetch('user', 'current_user')
     $user_hash = concat( $current_user.role_id_list|implode( ',' ), ',', $current_user.limited_assignment_value_list|implode( ',' ) )}
{include uri='design:parts/openpa/wrap_full_open.tpl'}

{def $servizio_utente = fetch( 'content', 'related_objects',
				hash( 'object_id', $current_user.contentobject_id, 'attribute_identifier', 909,'all_relations', false() ))
     $is_dipendente = false()
     $gruppo_dipendenti = ezini( 'ControlloUtenti', 'gruppo_dipendenti', 'openpa.ini')
     $gruppo_amministratori = ezini( 'ControlloUtenti', 'gruppo_amministratori', 'openpa.ini')
     $classes_figli = ezini( 'GestioneClassi', 'classi_figlie_da_includere', 'openpa.ini')
     $classes_figli_escludi = array()
     $classes_parent_to_edit=array('file_pdf', 'news')
     $oggetti_correlati = ezini( 'DisplayBlocks', 'oggetti_correlati', 'openpa.ini')
     $oggetti_correlati_centro = ezini( 'DisplayBlocks', 'oggetti_correlati_centro', 'openpa.ini')
     $sezioni_per_tutti= ezini( 'GestioneSezioni', 'sezioni_per_tutti', 'openpa.ini')
	 $classi_da_non_commentare=array( 'news', 'comment')
	 $style='col-odd'
}
{def $is_area_tematica = true()}

{* controlla che in nodo passato per referenza *}
{if is_set($view_parameters.reference)|not()}
	{set $view_parameters=$view_parameters|merge(hash('reference',0))}
{/if}
{if $view_parameters.reference|gt(0)}
	{node_view_gui view='full' is_area_tematica=true()  content_node=fetch(content,node,hash(node_id,$view_parameters.reference))}
{else}

<div class="border-box">
<div class="global-view-full content-view-full">
    <div class="class-folder">

        <div class="attribute-header">
            <h1>{attribute_view_gui attribute=$node.data_map.name}</h1>
	    <div class="last-modified">Ultima modifica: {$node.object.modified|l10n(date)}</div>
        </div>

        {include name=editor_tools node=$node current_user=$current_user uri='design:parts/openpa/editor_tools.tpl'}

        <div class="attributi-principali float-break col">
		<div class="col-content-design float-break">

        {if is_set($node.data_map.image)}
			{if $node.data_map.image.has_content}
				<div class="main-image left">
                {attribute_view_gui attribute=$node.data_map.image image_class='medium'}
                </div>
			{/if}
		{/if}
		{if $node|has_abstract()}
			{$node|abstract()}
		{/if}
		</div>


		<div class="date-workflow">
			{if is_set($node.data_map.data_iniziopubblicazione)}
				{if $node.data_map.data_iniziopubblicazione.has_content}
					<p><strong>{$node.data_map.data_iniziopubblicazione.contentclass_attribute_name}</strong>
					   {attribute_view_gui attribute=$node.data_map.data_iniziopubblicazione}
						{if is_set($node.data_map.data_finepubblicazione)}
							{if $node.data_map.data_finepubblicazione.has_content}
								- <strong>{$node.data_map.data_finepubblicazione.contentclass_attribute_name}</strong>
								  {attribute_view_gui attribute=$node.data_map.data_finepubblicazione}
							{/if}
						{/if}
						{if is_set($node.data_map.data_archiviazione)}
							{if $node.data_map.data_archiviazione.has_content}
								- <strong>{$node.data_map.data_archiviazione.contentclass_attribute_name}</strong>
								  {attribute_view_gui attribute=$node.data_map.data_archiviazione}</p>
							{/if}
						{/if}
					</p>
				{/if}
			{elseif is_set($node.data_map.data_archiviazione)}
				{if $node.data_map.data_archiviazione.has_content}
					<p><strong>{$node.data_map.data_archiviazione.contentclass_attribute_name}</strong>
					{attribute_view_gui attribute=$node.data_map.data_archiviazione}</p>
				{/if}
			{/if}
		</div>

		{* mostro la descrizione (attribute: description) *}

		<div class="col-content-design">
			{if and( is_set($node.data_map.description), $node.data_map.description.has_content )}
				{attribute_view_gui is_area_tematica=$is_area_tematica attribute=$node.data_map.description}
			{/if}
		</div>

		{if and( is_set( $node.data_map.gps ), $node.data_map.gps.has_content )}
		<div class="attributi-base">

			<div class="col-odd col float-break attribute-gps">
				<div class="col-title"><span class="label">Posizione GPS</span></div>
				<div class="col-content"><div class="col-content-design">
					{attribute_view_gui is_area_tematica=$is_area_tematica attribute=$node.data_map.gps}
				</div></div>
			</div>

		</div>
		{/if}

	</div>


{*CORRELAZIONI*}
	{* OGGETTI DIRETTAMENTE CORRELATI rispetto ad attributi specifici - oggetti_correlati_centro*}
	{include name=related_objects_attributes_spec
				node=$node
				title='Informazioni correlate:'
				is_area_tematica=$is_area_tematica
				oggetti_correlati=$oggetti_correlati_centro
				uri='design:parts/related_objects_attributes.tpl'}

{*OGGETTI INVERSAMENTE CORRELATI smart*}

		 {include name=reverse_related_objects
				node=$node
				is_area_tematica=$is_area_tematica
				title='Riferimenti:'
				classe='folder'
				attrib='riferimento'
				uri='design:parts/reverse_related_objects_specific_class_and_attribute.tpl'}



{*OGGETTI INVERSAMENTE CORRELATI*}

		 {*include name=reverse_related_objects
				node=$node
				is_area_tematica=$is_area_tematica
				title='Riferimenti:'
				uri='design:parts/reverse_related_objects.tpl'*}



{* mostro i figli *}


	{def     $page_limit = 25
		 $show_items=false()
		 $children=''
		 $children_count=''
		 $classes=''
		 $include_exclude=''
		 $gallery=''}

	{if and( is_set( $node.data_map.classi_filtro ), $node.data_map.classi_filtro.has_content )}
        	{set $classes = $node.data_map.classi_filtro.content|explode(',') $include_exclude='include'   $show_items=true() }
			{if and( is_set($node.data_map.subfolders), $node.data_map.subfolders.has_content)}
		        	{def $subtreenode_id =  $node.data_map.subfolders.content.relation_list.0.node_id}
			{else}
	        		{def $subtreenode_id=ezini( 'NodeSettings', 'RootNode', 'content.ini' )}
			{/if}
		{set    $children=fetch(content,tree,
						  hash( 'parent_node_id', $subtreenode_id,
							'offset', $view_parameters.offset,
							'sort_by', $node.object.main_node.sort_array,
							'class_filter_type', 'include',
							'class_filter_array', $classes,
							'limit', $page_limit))
			$children_count = fetch( 'content', 'tree_count',
						hash(parent_node_id, $subtreenode_id,
						 'class_filter_type', 'include',
						 'class_filter_array', $classes))
			$show_items=true() }

	{elseif $node.object.data_map.show_children.data_int}
            {set $page_limit = 20
                 $classes = ezini( 'ExcludedClassesAsChild', 'FromFolder', 'openpa.ini' )
                 $children = array()
		 $gallery = ''
                 $children_count = ''
		 $show_items=true()
	     }


		{set $gallery=fetch( 'content', 'list', hash( 'parent_node_id', $node.node_id,
                                                          'offset', $view_parameters.offset,
                                                          'sort_by', $node.sort_array,
                                                          'class_filter_type', 'include',
                                                          'class_filter_array', array('image'),
                                                          'limit', $page_limit ) )}
                {if $gallery|count()|gt(0)}
				{node_view_gui view='line_gallery' content_node=$node}
                {/if}

		{* in caso di gallerie fotografiche *}
            		{set $children=fetch( 'content', 'list',
						    hash( 'parent_node_id', $node.node_id,
                                                          'offset', $view_parameters.offset,
                                                          'sort_by', $node.sort_array,
                                                          'class_filter_type', 'include',
                                                          'class_filter_array', array('gallery'),
                                                          'limit', $page_limit ) )}
		   {if $children|count()|gt(0)}
			{set $style='col-odd'}
                		{foreach $children as $child }
						{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
						<div class="{$style} col float-break col-notitle">
						<div class="col-content"><div class="col-content-design">
							{node_view_gui view='line_gallery' content_node=$child}
						</div></div>
						</div>
                		{/foreach}
		   {/if}

        {if and( $node.data_map.alternativo.content, $node.children_count|eq(0) )}
            <div class="warning">In questo momento non ci sono "{$node.name}".</div>
        {/if}

		{* FIGLI *}
		{*if is_set($servizio)*}
		{if $servizio_utente|is_array()}
			{if $servizio_utente|count()|gt(0)}
				{def $servizioutente=$servizio_utente[0]}
			{else}
				{def $servizioutente=''}
			{/if}
		{else}
			{def $servizioutente=''}
		{/if}

				{include name=filtered_children
					current_user=$current_user
					object=$node.object
					classes_figli=$classes_figli
					classes_figli_escludi=$classes_figli_escludi
					classes_parent_to_edit=$classes_parent_to_edit
					title='Allegati'
					is_area_tematica=$is_area_tematica
					classi_da_non_commentare=$classi_da_non_commentare
					node=$node.object.main_node oggetti_correlati=$oggetti_correlati
					uri='design:parts/filtered_children.tpl'}


			{*/if*}


	    {* in generale *}
            {set $classes =  ezini( 'ExcludedClassesAsChild', 'FromFolder', 'openpa.ini' )}
            {set $children=fetch( 'content', 'list', hash( 'parent_node_id', $node.node_id,
                                                          'offset', $view_parameters.offset,
                                                          'sort_by', $node.sort_array,
                                                          'class_filter_type', 'exclude',
                                                          'class_filter_array', $classes,
                                                          'limit', $page_limit ) )
                 $children_count=fetch( 'content', 'list_count', hash( 'parent_node_id', $node.node_id,
                                                                      'class_filter_type', 'exclude',
                                                                      'class_filter_array', $classes ) )}

	{/if}
	{if $show_items}

		{if $children_count|gt(0)}

			{*ALTRI FIGLI*}
                	{foreach $children as $child }
					   {if $sezioni_per_tutti|contains($child.object.section_id)}
						{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
						<div class="{$style} col col-notitle float-break">
					   {else}
						<div class="square-box-gray float-break no-sezioni_per_tutti">
					   {/if}
						<div class="col-content"><div class="col-content-design">
							{node_view_gui is_area_tematica=$is_area_tematica view='line' show_image='no' content_node=$child}
						</div></div>
						</div>
               	 	{/foreach}


        	    	{include name=navigator
                	     uri='design:navigator/google.tpl'
	                     page_uri=$node.url_alias
        	             item_count=$children_count
                	     view_parameters=$view_parameters
	                     item_limit=$page_limit}
        	{/if}



        {/if}
    </div>

	{* TIP a friend *}
        	{def $tipafriend_access=fetch( 'user', 'has_access_to', hash( 'module', 'content', 'function', 'tipafriend' ) )}
        	{if and( ezmodule( 'content/tipafriend' ), $tipafriend_access )}
	        	<div class="attribute-tipafriend">
        		<a href={concat( "/content/tipafriend/", $node.node_id )|ezurl} title="{'Tip a friend'|i18n( 'design/ezwebin/full/article' )}">
				{'Tip a friend'|i18n( 'design/ezwebin/full/article' )}
			</a>
        		</div>
       		{/if}



</div>

</div>
{/if}

{include uri='design:parts/openpa/wrap_full_close.tpl'}