{*def $valore as ''*}
{def $valore = ''}
<tr class="{$sequence}">

<td>
	
    <h3>
		<a href={$node.url_alias|ezurl()}>{attribute_view_gui attribute=$node.data_map.titolo}</a>
	</h3>
        
    {if $node|has_abstract()}
    <div class="attribute-abstract">
        {$node|abstract()|openpa_shorten( 200 )}
    </div>
    {/if}

</td>


<td>
    <div class="argomento-blocco-attributi">
        {$node.object.published|l10n(date)}
    </div>
</td>

</tr>
