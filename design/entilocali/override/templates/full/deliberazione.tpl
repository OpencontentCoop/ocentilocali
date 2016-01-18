{include name=menu_control node=$node uri='design:parts/common/menu_control.tpl'}

{def $is_area_tematica = is_area_tematica()}

{def $reference=0}
{if is_set($view_parameters.reference)}
	{set $reference = $view_parameters.reference}
{/if}

{if $reference|gt(0)}
	{node_view_gui view='full' is_area_tematica=true() content_node=fetch( content, node, hash( node_id,$reference ) )}
{else}

{def $gruppo_dipendenti = ezini( 'ControlloUtenti', 'gruppo_dipendenti', 'openpa.ini')
	 $gruppo_amministratori = ezini( 'ControlloUtenti', 'gruppo_amministratori', 'openpa.ini')
	 $oggetti_correlati = ezini( 'DisplayBlocks', 'oggetti_correlati', 'openpa.ini')
	 $oggetti_classificazione = ezini( 'DisplayBlocks', 'oggetti_classificazione', 'openpa.ini')
	 $oggetti_correlati_centro = ezini( 'DisplayBlocks', 'oggetti_correlati_centro', 'openpa.ini')
	 $oggetti_senza_label = ezini( 'GestioneAttributi', 'oggetti_senza_label', 'openpa.ini')
	 $attributi_da_escludere = ezini( 'GestioneAttributi', 'attributi_da_escludere', 'openpa.ini')
	 $attributi_da_evidenziare = ezini( 'GestioneAttributi', 'attributi_da_evidenziare', 'openpa.ini')
	 $attributi_a_destra = ezini( 'GestioneAttributi', 'attributi_a_destra', 'openpa.ini')
	 $attributi_allegati_atti = ezini( 'GestioneAttributi', 'attributi_allegati_atti', 'openpa.ini')
	 $attributi_senza_link = ezini( 'GestioneAttributi', 'attributi_senza_link', 'openpa.ini')
	 $classes = ezini( 'GestioneClassi', 'classi_figlie_da_escludere', 'openpa.ini')
	 $classes_figli = ezini( 'GestioneClassi', 'classi_figlie_da_includere', 'openpa.ini')
	 $classes_figli_escludi = ezini( 'GestioneClassi', 'classi_figlie_da_escludere', 'openpa.ini')
	 $classi_commentabili = ezini( 'GestioneClassi', 'classi_commentabili', 'openpa.ini')
	 $classes_edizioni_figli = array( 'edizione', 'edizione_lunga')
	 $classes_parent_to_edit = array( 'file_pdf', 'news', 'edizione', 'edizione_lunga')
	 $classi_da_non_commentare = array( 'news', 'comment')	
	 $classi_senza_correlazioni_inverse = ezini( 'GestioneClassi', 'classi_senza_correlazioni_inverse', 'openpa.ini')
	 $current_user = fetch( 'user', 'current_user' )
	 $has_servizio = 'none'
	 $servizio = array()
	 $is_dipendente = false()
	 $servizio_utente = fetch( 'content', 'related_objects',hash( 'object_id', $current_user.contentobject_id, 'attribute_identifier', openpaini( 'ControlloUtenti', 'user_servizio_attribute_ID', 909 ),'all_relations', false() )) 
	 $classi_con_servizi = wrap_user_func('getClassAttributes', array(array('servizio')) )
	 $parent_con_servizio = false()
	 $classe_con_servizio = false()
}

{foreach $classi_con_servizi as $ccs}
	{if $ccs.identifier|eq($node.parent.class_identifier)}
		{set $parent_con_servizio = true() }
	{/if}
	{if $ccs.identifier|eq($node.class_identifier)}
		{set $classe_con_servizio = true() }
	{/if}
{/foreach}

{if $classes_parent_to_edit|contains($node.class_identifier)}
	{if $parent_con_servizio}
		{set $servizio = fetch( 'content', 'related_objects',  hash( 'object_id', $node.parent.object.id, 'attribute_identifier', concat($node.parent.class_identifier, '/servizio'),'all_relations', false() )) }
		{if $servizio|gt(0)}
			{set $has_servizio='ok'}
		{/if}
	{/if}
{else}
	{if $classe_con_servizio}
		{set $servizio = fetch( 'content', 'related_objects',  hash( 'object_id', $node.object.id, 'attribute_identifier', concat($node.class_identifier, '/servizio'), 'all_relations', false() )) }
		{if $servizio|gt(0)}
			{set $has_servizio='ok'}
		{/if}
	{/if}
{/if}	

<div class="border-box">
<div class="border-content">

 <div class="global-view-full content-view-full">
  <div class="class-{$node.object.class_identifier}">

	<h1>{$node.object.class_name} del {attribute_view_gui attribute=$node.data_map.data_iniziopubblicazione}</h1>
	<div class="last-modified">di {$node.object.published|l10n(date)} {if $node.object.modified|gt(sum($node.object.published,86400))}- Ultima modifica: <strong>{$node.object.modified|l10n(date)}{/if}</strong></div>
	
	{include name=editor_tools node=$node current_user=$current_user uri='design:parts/openpa/editor_tools.tpl'}

	{* ATTRIBUTI : mostra i contenuti del nodo *}   
	<div class="attributi-principali float-break col col-notitle">
	<div class="col-content"><div class="col-content-design">
		{if is_set($node.data_map.image)}
			{if $node.data_map.image.has_content}
				<div class="main-image left">
                {attribute_view_gui attribute=$node.data_map.image image_class='medium'}
                </div>
			{/if}		
		{/if}	

        {if and( is_set( $node.data_map.abstract ), $node.data_map.abstract.has_content )}
            {attribute_view_gui is_area_tematica=$is_area_tematica attribute=$node.data_map.abstract}
        {/if}
	</div></div>
	</div>
	
	<div class="attributi-base">
	{def $style='col-odd'}
   	{foreach $node.object.contentobject_attributes as $attribute}
		{if and( $attribute.has_content, $attribute.content|ne('0') )}
			{if $attributi_da_escludere|contains( $attribute.contentclass_attribute_identifier )|not()}
				{if $style|eq( 'col-even' )}{set $style = 'col-odd'}{else}{set $style = 'col-even'}{/if}
				{if $oggetti_senza_label|contains( $attribute.contentclass_attribute_identifier )|not()}
				   <div class="{$style} col float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-title"><span class="label">{$attribute.contentclass_attribute_name}</span></div>
						<div class="col-content"><div class="col-content-design">
							{if $attributi_senza_link|contains( $attribute.contentclass_attribute_identifier )}
								{attribute_view_gui href='nolink' is_area_tematica=$is_area_tematica attribute=$attribute}
							{else}
								{attribute_view_gui is_area_tematica=$is_area_tematica attribute=$attribute}
							{/if}
						</div></div>
				   </div>
				{else}
				   <div class="{$style} col col-notitle float-break attribute-{$attribute.contentclass_attribute_identifier}">
					<div class="col-content"><div class="col-content-design">
						{if $attributi_senza_link|contains( $attribute.contentclass_attribute_identifier )}
							{attribute_view_gui href='nolink' is_area_tematica=$is_area_tematica attribute=$attribute}
						{else}
							{attribute_view_gui is_area_tematica=$is_area_tematica attribute=$attribute}
						{/if}
					</div></div>
				   </div>
				{/if}
			{/if} 
		{else}
			{if $attribute.contentclass_attribute_identifier|eq('ezflowmedia')}
				{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
					<div class="{$style} col float-break attribute-fullbase-{$attribute.contentclass_attribute_identifier} {if $oggetti_senza_label|contains($attribute.contentclass_attribute_identifier)}col-notitle{/if}">
						<div class="col-content"><div class="col-content-design">
						{attribute_view_gui is_area_tematica=$is_area_tematica attribute=$attribute}
						</div></div>
					</div>
			{/if}		
		{/if}
	{/foreach}
	</div>


{*CORRELAZIONI*}
	{* OGGETTI DIRETTAMENTE CORRELATI rispetto ad attributi specifici - oggetti_correlati_centro*}   
	{include name=related_objects_attributes_spec 
				node=$node
				title='Informazioni correlate:'
				is_area_tematica=$is_area_tematica
				oggetti_correlati=$oggetti_correlati_centro 
				uri='design:parts/related_objects_attributes.tpl'}


{*ALLEGATI E ANNESSI DI ATTI RELAZIONATI*}
	{* MOSTRA ALLEGATI E ANNESSI RELAZIONATI: iter, pareri, allegati di ATTI ecc *}
	{include name=allegati_e_annessi
				node=$node 
				title='Allegati'
				is_area_tematica=$is_area_tematica
				attributi_rilevanti=$attributi_allegati_atti 
				uri='design:parts/allegati_e_annessi.tpl'}
  

{*OGGETTI CORRELATI SPECIFICI - CLASSIFICAZIONE*}
	{* OGGETTI CORRELATI rispetto ad attributi specifici - oggetti_classificazione *}   
	{include name=related_objects_attributes 
				node=$node 
				is_area_tematica=$is_area_tematica
				title="Classificazione dell'informazione"
				oggetti_correlati=$oggetti_classificazione 
				uri='design:parts/related_objects_attributes.tpl'}




{*OGGETTI INVERSAMENTE CORRELATI*}

		 {include name=reverse_related_objects 
				node=$node 
				is_area_tematica=$is_area_tematica
				title='Riferimenti:'
				uri='design:parts/reverse_related_objects.tpl'}


{*FIGLI*}
	{* FIGLI di un tipo selezionato *}	
	{*if and(is_array($servizio),is_array($servizio_utente))*} {* controlla se esistono le variabili $servizio e $servizio_utente altrimenti genera un errore *}
		{*if and(is_set($servizio[0]),is_set($servizio_utente[0]))*}
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
					classes_figli=$classes_edizioni_figli 
					classes_figli_escludi=$classes_figli_escludi
					classes_parent_to_edit=$classes_parent_to_edit
					title='Edizioni'
					
					is_area_tematica=$is_area_tematica
					classi_da_non_commentare=$classi_da_non_commentare
					node=$node.object.main_node oggetti_correlati=$oggetti_correlati 
					uri='design:parts/filtered_children.tpl'}
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
		{*include name=filtered_children 
					current_user=$current_user 
					object=$node.object
					has_servizio=$has_servizio 
					servizio_utente=$servizioutente
					servizio=$servizio[0]
					classes_figli=$classes_figli
					classes_figli_escludi=$classes_figli_escludi
					classes_parent_to_edit=$classes_parent_to_edit
					title='Allegati'
					is_area_tematica=$is_area_tematica
					classi_da_non_commentare=$classi_da_non_commentare
					node=$node.object.main_node oggetti_correlati=$oggetti_correlati 
					uri='design:parts/filtered_children.tpl'*}
		{*/if*}
	{*/if*}


{*GALLERIA*}
	{* GALLERIA fotografica *}   
	{def $galleries=fetch('content', 'list', hash('parent_node_id', $node.node_id, 'sort_by', $node.sort_array,
                                                'class_filter_type', 'include', 'class_filter_array', array('image')))}
	{if $galleries|count()|gt(0)}
			{include name=galleria 	node=$node uri='design:node/view/line_gallery.tpl'}
	{/if}

{*TIP A FRIEND*}
	{* TIP a friend *}
        {def $tipafriend_access=fetch( 'user', 'has_access_to', hash( 'module', 'content', 'function', 'tipafriend' ) )}
        {if and( ezmodule( 'content/tipafriend' ), $tipafriend_access )}
	        <div class="attribute-tipafriend">
        	<a href={concat( "/content/tipafriend/", $node.node_id )|ezurl} 
			title="{'Tip a friend'|i18n( 'design/standard/content/tipafriend' )}">{'Tip a friend'|i18n( 'design/standard/content/tipafriend' )}</a>
        	</div>
        {/if}

{*if $is_dipendente*}
{*NEWS*}
	{* VISUALIZZAZIONE E CREAZIONE DI NEWS *}
    	{if $node.object.content_class.is_container}
		{include name=create_comment 
				node=$node current_user=$current_user object=$node.object
				classes_parent_to_edit=$classes_parent_to_edit
				classi_da_non_commentare=$classi_da_non_commentare
				uri='design:parts/websitetoolbar/create_news.tpl'}
		{*include name=create_comment 
				node=$node current_user=$current_user object=$node.object
				has_servizio=$has_servizio servizio_utente=$servizio_utente[0]
				servizio=$servizio[0]
				classes_parent_to_edit=$classes_parent_to_edit
				classi_da_non_commentare=$classi_da_non_commentare
				uri='design:parts/websitetoolbar/create_news.tpl'*}
    	{/if}
{*/if*}

{*COMMENTI*}
	{* COMMENTI *}
    	{if $classi_commentabili|contains($node.class_identifier)}
		{include name=create_comment node=$node uri='design:parts/websitetoolbar/create_comment.tpl'}
  	{/if}
	
    </div>
</div>

</div>
</div>
{/if}
