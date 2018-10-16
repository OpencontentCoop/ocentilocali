<div id="links">
    <div id="links-design">
        <h2 class="hide">Menu di utilit&agrave;</h2>
        <ul>

            <li id="login" style="display: none;">
                <a style="border: none;" href={"/user/login"|ezurl} title="Login">Login</a>
            </li>

            {if openpaini( 'LinkSpeciali', 'NodoContattaci' )}
                {def $link_contatti = fetch('content','node',hash('node_id', openpaini('LinkSpeciali', 'NodoContattaci') ))}
                <li id="contatti" class="no-js-hide">
                    <a href={$link_contatti.url_alias|ezurl()} title="Trova il modo migliore per
                       contattarci">Contatti</a>
                </li>
            {/if}

            {include uri='design:page_header_languages.tpl'}

        </ul>
    </div>
</div>

<script>{literal}
$(document).ready(function(){
	var injectUserInfo = function(data){
		if(data.error_text || !data.content){
			$('#login').show();
		}else{
			$('#login').after('<li id="myprofile"><a href="/user/edit/" title="Visualizza il profilo utente">Il mio profilo</a></li><li id="logout"><a style="border: none;" href="/user/logout" title="Logout">Logout ('+data.content.name+')</a></li>');
			if(data.content.has_access_to_dashboard){
				$('#login').after('<li id="dashboard"><a href="/content/dashboard/" title="Pannello strumenti">Pannello strumenti</a></li>');
			}
		}
	};
	if(CurrentUserIsLoggedIn){
		$.ez('openpaajax::userInfo', null, function(data){
			injectUserInfo(data);
		});
	}else{
		$('#login').show();
	}
});
{/literal}</script>