{if $current_node.can_edit}
    <a href={concat( "/ezflow/push/", $current_node.node_id )|ezurl} title="{'Add to block in frontpage'|i18n( 'design/ezflow/parts/website_toolbar' )}"><img class="ezwt-input-image" src={"websitetoolbar/ezwt-icon-push.png"|ezimage()} alt="{'Add to block in frontpage'|i18n( 'design/ezflow/parts/website_toolbar' )}" /></a>
{/if}