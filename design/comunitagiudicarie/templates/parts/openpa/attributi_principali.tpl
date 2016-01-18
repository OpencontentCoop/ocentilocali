{def $attributi_da_escludere = openpaini( 'GestioneAttributi', 'attributi_da_escludere' )
     $oggetti_senza_label = openpaini( 'GestioneAttributi', 'oggetti_senza_label' )
     $attributi_senza_link = openpaini( 'GestioneAttributi', 'attributi_senza_link' )
     $attributi_da_evidenziare = openpaini( 'GestioneAttributi', 'attributi_da_evidenziare', array())}

{if or(
    and( is_set($node.data_map.image), $node.data_map.image.has_content ),
    and( is_set( $node.data_map.ruolo ), $node.data_map.ruolo.has_content ),
    and( is_set( $node.data_map.ruolo2 ), $node.data_map.ruolo2.has_content ),
    and( is_set( $node.data_map.oggetto ), $node.data_map.oggetto.has_content ),
    and( is_set( $node.data_map.abstract ), $node.data_map.abstract.has_content ),
    and( is_set( $node.data_map.short_description ), $node.data_map.short_description.has_content ),
    or( is_set($node.data_map.data_iniziopubblicazione), is_set($node.data_map.data_archiviazione) )
)}

<div class="attributi-principali float-break col col-notitle">
	<div class="col-content"><div class="col-content-design">
		{if and( is_set($node.data_map.image), $node.data_map.image.has_content )}
        <div class="main-image left">
            {attribute_view_gui attribute=$node.data_map.image image_class='medium'}
		</div>
        {/if}

		{if and( is_set( $node.data_map.ruolo ), $node.data_map.ruolo.has_content )}
			{attribute_view_gui attribute=$node.data_map.ruolo}			
		{elseif and( is_set( $node.data_map.ruolo2 ), $node.data_map.ruolo2.has_content )}
            {attribute_view_gui attribute=$node.data_map.ruolo2}
		{/if}
 
		{if and( is_set( $node.data_map.oggetto ), $node.data_map.oggetto.has_content )}
			{attribute_view_gui attribute=$node.data_map.oggetto}
		{elseif and( is_set( $node.data_map.abstract ), $node.data_map.abstract.has_content )}
			{attribute_view_gui attribute=$node.data_map.abstract}
        {elseif and( is_set( $node.data_map.short_description ), $node.data_map.short_description.has_content )}
			{attribute_view_gui attribute=$node.data_map.short_description}
		{/if}
        
	</div></div>
</div>
{/if}