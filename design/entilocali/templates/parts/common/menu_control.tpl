{*if or(
    openpaini( 'ExtraMenu', 'NascondiNeiNodi', array( 0 ) )|contains($node.node_id),
    openpaini( 'ExtraMenu', 'NascondiNelleClassi', array( 0 ) )|contains($node.class_identifier),
    openpaini( 'ExtraMenu', 'Nascondi', false() )|eq( 'true' )
)}
    {ezpagedata_set( 'extra_menu', false() )}
{/if*}
{* vedi https://support.opencontent.it/consorzio_comuni/ticket/475 *}
{if and( is_set( $node.data_map.classi_filtro ), $node.data_map.classi_filtro.has_content )}
    {ezpagedata_set( 'extra_menu', true() )}
{else}
    {ezpagedata_set( 'extra_menu', false() )}
{/if}

{if or(
    openpaini( 'SideMenu', 'NascondiNeiNodi', array( 0 ) )|contains($node.node_id),
    openpaini( 'SideMenu', 'NascondiNelleClassi', array( 0 ) )|contains($node.class_identifier),
    $node.parent.class_identifier|eq( 'comune' )
)}
	{ezpagedata_set( 'left_menu', false() )}
{/if}