{if or($attribute.data_text|contains( 'http://' ), $attribute.data_text|contains( 'https://' ))}
<a href="{$attribute.data_text|wash( xhtml )}" title="Visita il sito ufficiale del {$attribute.object.name|wash()}">
    <strong>{$attribute.data_text|wash( xhtml )}</strong>
</a>
{else}
    {$attribute.data_text|wash( xhtml )}
{/if}