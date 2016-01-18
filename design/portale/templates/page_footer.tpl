</div>
</div>

    <div id="footer">
    <div id="footer-design" class="width-layout">
        
        <address>
            {if is_set($pagedesign.data_map.hide_powered_by)}
                {def $credits = cond( openpaini( 'LinkSpeciali', 'NodoCredits'), fetch( content, node, hash( node_id, openpaini( 'LinkSpeciali', 'NodoCredits') ) ), false())
                     $note = cond( openpaini( 'LinkSpeciali', 'NodoNoteLegali'), fetch( content, node, hash( node_id, openpaini( 'LinkSpeciali', 'NodoNoteLegali') ) ), false() )
                     $dichiarazione = cond( openpaini( 'LinkSpeciali', 'NodoDichiarazione'), fetch( content, node, hash( node_id, openpaini( 'LinkSpeciali', 'NodoDichiarazione') ) ), false() )}
                
                {if $note}<a href={$note.url_alias|ezurl()} title="Leggi le note legali">note legali</a> - {/if}
                {if $credits}<a title="Leggi i credits" href={$credits.url_alias|ezurl()}>credits</a> - {/if}
                {if $dichiarazione}<a title="Leggi la dichiarazione di accessibilit&agrave;" href={$dichiarazione.url_alias|ezurl()}>dichiarazione di accessibilit&agrave;</a> - {/if} 
                powered by <a href="http://www.ez.no" title="eZ Publish - Enterprise Content Management System Open Source">eZ publish</a> and <a href="http://www.opencontent.it" title="OpenContent - Free Software Solutions">OpenContent</a><br />
            {/if}
        </address>
    </div>
    </div>
