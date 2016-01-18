<div id="links">
<div id="links-design">
<h2 class="hide">Menu di utilit&agrave;</h2>
<ul>
    <li><a href={"/"|ezurl()}>Portale del territorio</a></li>
{if and($current_user.is_logged_in, $current_user.login|ne('utente'))}	
	{if $pagedesign.data_map.logout_label.has_content}
	<li id="logout"><a href={"/user/logout"|ezurl} title="{$pagedesign.data_map.logout_label.data_text|wash}">{$pagedesign.data_map.logout_label.data_text|wash} ( {$current_user.contentobject.name|wash} )</a></li>
	{/if}
{else}
	{if is_set($pagedesign.data_map.login_label)}
		{if $pagedesign.data_map.login_label.has_content}
		<li id="login" class="lastli"><a href={"/user/login"|ezurl} title="{$pagedesign.data_map.login_label.data_text|wash}">{$pagedesign.data_map.login_label.data_text|wash}</a></li>
		{/if}
	{/if}
{/if}

{if openpaini( 'LinkSpeciali', 'NodoContattaci' )}
    {def $link_contatti = fetch('content','node',hash('node_id', openpaini('LinkSpeciali', 'NodoContattaci') ))}
	<li id="contatti" class="no-js-hide">
		<a href={$link_contatti.url_alias|ezurl()} title="Trova il modo migliore per contattarci">Contatti</a>
	</li>
{/if}

{include uri='design:page_header_languages.tpl'}

</ul>
</div>
</div>