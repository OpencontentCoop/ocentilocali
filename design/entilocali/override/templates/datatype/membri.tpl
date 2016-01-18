{if $attribute.content.relation_list}
    {foreach $attribute.content.relation_list as $item}
    {if $item.in_trash|not()}
        {def $object=fetch( content, object, hash( object_id, $item.contentobject_id ) )}
        <p class="membro split-2">
            {if and( is_set( $object.data_map.image ), $object.data_map.image.has_content )}
            {attribute_view_gui attribute=$object.data_map.image image_class=small}<br />
            {/if}
            <a href="{$object.main_node.url_alias|ezurl(no)}" title="Profilo di {$object.name|wash()}">{$object.name|wash()}</a>
        </p>
        {undef $object}
    {/if}
    {/foreach}
{/if}