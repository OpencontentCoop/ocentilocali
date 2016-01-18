{*?template charset=utf-8?*}
{*
	TEMPLATE VIDE LINE
	mode		modalita' in cui visualizzare i link
	show_image 	modalita' di visualizzazione delle icone rappresentative della classe se non è valorizzata un'immagine
*}
{def 	$classes_parent_to_edit=array('file_pdf', 'news')
	$current_user = fetch( 'user', 'current_user' )
	$has_servizio='none'
        $servizio = array()
	$classi_senza_data_inline = ezini( 'GestioneClassi', 'classi_senza_data_inline', 'openpa.ini')
	$classi_senza_correlazioni_inline = ezini( 'GestioneClassi', 'classi_senza_correlazioni_inline', 'openpa.ini')
	$classi_con_immagine_inline = ezini( 'GestioneClassi', 'classi_con_immagine_inline', 'openpa.ini')
	$classi_senza_immagine_inline = ezini( 'GestioneClassi', 'classi_senza_immagine_inline', 'openpa.ini')
	$attributes_with_title= ezini( 'GestioneAttributi', 'attributes_with_title', 'openpa.ini')
	$attributes_to_show= ezini( 'GestioneAttributi', 'attributes_to_show', 'openpa.ini')
        $servizio_utente = fetch( 'content', 'related_objects',
                                hash( 'object_id', $current_user.contentobject_id, 'attribute_identifier',  openpaini( 'ControlloUtenti', 'user_servizio_attribute_ID', 909 ),'all_relations', false() ))
}

{if is_set($is_area_tematica)|not()}
	{def $is_area_tematica=is_area_tematica()}
{/if}

{if is_set($mode)}
	{def $mode_link=$mode}
{else}
	{def $mode_link=''}
{/if}

{if is_set($show_image)}
	{def $show_icon_image=$show_image}
{else}
	{def $show_icon_image=''}
{/if}

<div class="class-documento">

	{if $classi_senza_immagine_inline|contains($node.class_identifier)|not()}
		{if is_set($node.data_map.image)}
			{if $show_icon_image|ne('nessuna')}
				{if $node.data_map.image.has_content}
					<div class="main-image left">{attribute_view_gui attribute=$node.data_map.image image_class='small'}</div>
				{/if}
			{/if}
		{/if}
	{/if}

	<div class="blocco-titolo-oggetto">
        
 		<div class="titolo-blocco-titolo">
			<h3><a href={$node.url_alias|ezurl()} title="{attribute_view_gui attribute=$node.data_map.oggetto}">{attribute_view_gui attribute=$node.data_map.oggetto}</a></h3>
		</div>
		
		{if $classi_senza_data_inline|contains($node.class_identifier)|not}
		<div class="published">
			di {$node.object.published|l10n(date)}
		</div>
		{/if}

	</div>
</div>

