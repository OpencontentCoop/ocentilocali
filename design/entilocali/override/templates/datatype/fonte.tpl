{if $attribute.data_text|contains( 'http://' )}
<a target="_blank" href="{$attribute.data_text|wash( xhtml )}" title="Visita la fonte: {$attribute.object.name|wash()}. Il contenuto si apre in una nuova pagina o scheda del browser">
    {$attribute.data_text|wash( xhtml )}
</a>
{else}
    {$attribute.data_text|wash( xhtml )}
{/if}