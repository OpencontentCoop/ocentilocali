{* Folder - Line view *}

{def $classi_con_immagine_inline = ezini( 'GestioneClassi', 'classi_con_immagine_inline', 'openpa.ini')
     $classi_senza_immagine_inline = ezini( 'GestioneClassi', 'classi_senza_immagine_inline', 'openpa.ini')}

<div class="content-view-line">
    <div class="class-folder">
	{*if $classi_con_immagine_inline|contains($node.class_identifier)*}
		{if $node.data_map.image.has_content}
			<div class="main-image left">{attribute_view_gui attribute=$node.data_map.image image_class='small'}</div>
		{/if}
	
	{*/if*}
	<div class="blocco-titolo-oggetto">
		<div class="titolo-blocco-titolo">
		        <h3><a href={$node.url_alias|ezurl}>{$node.name|wash()}</a></h3>
		</div>
       	{if $node|has_abstract()}
        	<div class="attribute-short">
     	   		{$node|abstract()}
        	</div>
       	{/if}
	</div>

    </div>
</div>
