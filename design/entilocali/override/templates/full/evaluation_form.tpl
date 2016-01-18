{include name=menu_control node=$node uri='design:parts/common/menu_control.tpl'}

<div class="border-box">
<div class="global-view-full content-view-full">
    <div class="class-feedback-form">

    <h1>{$node.name|wash()}</h1>

    {* EDITOR TOOLS *}
	{include name = editor_tools
             node = $node             
             uri = 'design:parts/openpa/editor_tools.tpl'}

	{* ATTRIBUTI : mostra i contenuti del nodo *}
    {include name = attributi_principali
             uri = 'design:parts/openpa/attributi_principali.tpl'
             node = $node}
 
    {include name=Validation uri='design:content/collectedinfo_validation.tpl'
            class='message-warning'
            validation=$validation collection_attributes=$collection_attributes}

    <form method="post" action={"content/action"|ezurl}>

        {foreach $node.data_map as $attribute}
            {if $attribute.contentclass_attribute.is_information_collector|gt(0)}                    
                <div class="attribute-{$attribute.identifier}">
                    <h4>{$attribute.contentclass_attribute.name}</h4>     
                    {attribute_view_gui attribute=$attribute}
                    <hr />
                </div>
            {/if}
        {/foreach}

        <div class="content-action">
            <input type="submit" class="defaultbutton" name="ActionCollectInformation" value="{"Send form"|i18n("design/ezwebin/full/feedback_form")}" />
            <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
            <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
            <input type="hidden" name="ViewMode" value="full" />
        </div>
    </form>

    </div>

</div>
</div>
