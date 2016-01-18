<div class="menu-preview-design">
<h2><a href={$node.url_alias|ezurl()} title="Vai a {$node.name|wash()}">{$node.name|wash()}</a></h2>
{if $node|has_abstract()}
    {$node|abstract()}
{/if}
</div>