                    {if $homepage.node_id|eq($node.node_id)}
                        {include uri='design:parts/banner_carousel.tpl'}
                    {/if}
                </div>
            </div>
        </div>

        {if $extra_info}
            {$extra_info_content}
        {/if}

    </div>
    </div></div></div>
    <div class="columns-bl"><div class="columns-br"><div class="columns-bc"></div></div></div>
</div>

{if $node.class_identifier|eq('comune')}
    {ezpagedata_set( 'page_title', $node.name|wash() )}
{/if}

{* aiutaci a migliorare *}
{if and( $homepage.node_id|ne($node.node_id), $node.class_identifier|ne('frontpage'), $node.class_identifier|ne('homepage'), is_set($persistent_variable.hide_valuation)|not() ) }
    {include name=valuation node_id=$node.node_id uri='design:parts/openpa/valuation.tpl'}
{/if}

{if is_set( $homepage.data_map.sensor_footer_banner )}
    {ezpagedata_set( 'has_footer_banner',  true() )}
    {ezpagedata_set( 'footer_banner_url',  $homepage.data_map.sensor_footer_banner.content )}
    {ezpagedata_set( 'footer_banner_text',  hash('data_text', $homepage.data_map.sensor_footer_banner.data_text ))}
{/if}

{include uri='design:parts/load_website_toolbar.tpl'}