{ezscript_require(array( 'ezjsc::jquery' ) )}
<script type="text/javascript">{literal}
$(document).ready(function(){  
    var search = "{/literal}{'Search'|i18n('design/ezwebin/pagelayout')}{literal}";
    function hide_text(){
        if ($(this).val() == search)
            $(this).val('');
    }
    function show_text(){
        if ($(this).val() == '')
            $(this).val(search);
    }
    $('#searchbox_text').val(search);
    $('#searchbox_text').bind('focus', hide_text)
    $('#searchbox_text').bind('blur',  show_text)
});
{/literal}</script>
  
<div id="searchbox">
    <form action={"/content/search"|ezurl}>
        <fieldset>
            <legend class="hide">Strumenti di ricerca</legend>
            <label for="searchbox_text" class="hide">{'Search'|i18n('design/ezwebin/pagelayout')}</label>
                <input id="searchbox_text" name="SearchText" type="text" value="{'Search'|i18n('design/ezwebin/pagelayout')}" size="12" />
                <input id="facet_field" name="facet_field" value="class" type="hidden" />
                <input type="hidden" value="{'Search'|i18n('design/ezwebin/pagelayout')}" name="SearchButton" />
                <button name="SearchButton" value="Cerca" id="searchbox_submit" type="submit" class="button searchbutton">
                    {'Search'|i18n('design/ezwebin/pagelayout')}
                </button>
            {if is_area_tematica()}
                <input type="hidden" value="{is_area_tematica().node_id}" name="SubTreeArray[]" />
            {/if}
        </fieldset>
    </form>
</div>
