<div id="comunita_zone">

<div class="columns-three">
<div class="col-1-2">
<div class="col-1">
<div class="col-content">

    <div class="border-box box-trans-white">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
    <div class="border-ml"><div class="border-mr"><div class="border-mc">
    <div class="border-content">
    
        {if and( is_set( $zones[0].blocks ), $zones[0].blocks|count() )}
        {foreach $zones[0].blocks as $block}
        {if or( $block.valid_nodes|count(), 
            and( is_set( $block.custom_attributes), $block.custom_attributes|count() ), 
            and( eq( ezini( $block.type, 'ManualAddingOfItems', 'block.ini' ), 'disabled' ), ezini_hasvariable( $block.type, 'FetchClass', 'block.ini' )|not ) )}
            <div id="address-{$block.zone_id}-{$block.id}">
            {block_view_gui block=$block}
            </div>
        {/if}
        {/foreach}
        {/if}
    
    </div>
    </div></div></div>
    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
    </div>

</div>
</div>
<div class="col-2">
<div class="col-content">

    <div class="border-box box-trans-white">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
    <div class="border-ml"><div class="border-mr"><div class="border-mc">
    <div class="border-content">

        {if and( is_set( $zones[1].blocks ), $zones[1].blocks|count() )}
        {foreach $zones[1].blocks as $block}
        {if or( $block.valid_nodes|count(), 
            and( is_set( $block.custom_attributes), $block.custom_attributes|count() ), 
            and( eq( ezini( $block.type, 'ManualAddingOfItems', 'block.ini' ), 'disabled' ), ezini_hasvariable( $block.type, 'FetchClass', 'block.ini' )|not ) )}
            <div id="address-{$block.zone_id}-{$block.id}">
            {block_view_gui block=$block}
            </div>
        {/if}
        {/foreach}
        {/if}

    </div>
    </div></div></div>
    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
    </div>

</div>
</div>
</div>
<div class="col-3">
<div class="col-content">

    <div class="border-box box-trans-white">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
    <div class="border-ml"><div class="border-mr"><div class="border-mc">
    <div class="border-content">

        {if and( is_set( $zones[2].blocks ), $zones[2].blocks|count() )}
        {foreach $zones[2].blocks as $block}
        {if or( $block.valid_nodes|count(), 
            and( is_set( $block.custom_attributes), $block.custom_attributes|count() ), 
            and( eq( ezini( $block.type, 'ManualAddingOfItems', 'block.ini' ), 'disabled' ), ezini_hasvariable( $block.type, 'FetchClass', 'block.ini' )|not ) )}
            <div id="address-{$block.zone_id}-{$block.id}">
            {block_view_gui block=$block}
            </div>
        {/if}
        {/foreach}
        {/if}

    </div>
    </div></div></div>
    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
    </div>

</div>
</div>
</div>

<div class="block-separator"></div>

{if or( is_set( $zones[3].blocks ), $zones[3].blocks|count(), is_set( $zones[4].blocks ), $zones[4].blocks|count(), is_set( $zones[5].blocks ), $zones[5].blocks|count() )}

    
    <div class="border-box box-trans-white">
    <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
    <div class="border-ml"><div class="border-mr"><div class="border-mc">
    <div class="border-content">
    
    {if and( is_set( $zones[3].blocks ), $zones[3].blocks|count(), is_set( $zones[4].blocks ), $zones[4].blocks|count(), is_set( $zones[5].blocks ), $zones[5].blocks|count() )}
        
        <div class="columns-three">
        <div class="col-1-2">
        <div class="col-1">
        <div class="col-content">
    
            {if and( is_set( $zones[3].blocks ), $zones[3].blocks|count() )}
            {foreach $zones[3].blocks as $block}
            {if or( $block.valid_nodes|count(), 
                and( is_set( $block.custom_attributes), $block.custom_attributes|count() ), 
                and( eq( ezini( $block.type, 'ManualAddingOfItems', 'block.ini' ), 'disabled' ), ezini_hasvariable( $block.type, 'FetchClass', 'block.ini' )|not ) )}
                <div id="address-{$block.zone_id}-{$block.id}">
                {block_view_gui block=$block}
                </div>
            {/if}
            {/foreach}
            {/if}
        
        </div>
        </div>
        <div class="col-2">
        <div class="col-content">
    
            {if and( is_set( $zones[4].blocks ), $zones[4].blocks|count() )}
            {foreach $zones[4].blocks as $block}
            {if or( $block.valid_nodes|count(), 
                and( is_set( $block.custom_attributes), $block.custom_attributes|count() ), 
                and( eq( ezini( $block.type, 'ManualAddingOfItems', 'block.ini' ), 'disabled' ), ezini_hasvariable( $block.type, 'FetchClass', 'block.ini' )|not ) )}
                <div id="address-{$block.zone_id}-{$block.id}">
                {block_view_gui block=$block}
                </div>
            {/if}
            {/foreach}
            {/if}
        
        </div>
        </div>
        </div>
        <div class="col-3">
        <div class="col-content">
    
            {if and( is_set( $zones[5].blocks ), $zones[5].blocks|count() )}
            {foreach $zones[5].blocks as $block}
            {if or( $block.valid_nodes|count(), 
                and( is_set( $block.custom_attributes), $block.custom_attributes|count() ), 
                and( eq( ezini( $block.type, 'ManualAddingOfItems', 'block.ini' ), 'disabled' ), ezini_hasvariable( $block.type, 'FetchClass', 'block.ini' )|not ) )}
                <div id="address-{$block.zone_id}-{$block.id}">
                {block_view_gui block=$block}
                </div>
            {/if}
            {/foreach}
            {/if}
    
        </div>
        </div>
        </div>
    
    {elseif and( is_set( $zones[3].blocks ), $zones[3].blocks|count(), is_set( $zones[4].blocks ), $zones[4].blocks|count() )}
    
        <div class="columns-two">
        <div class="col-1">
        <div class="col-content">
    
            {if and( is_set( $zones[3].blocks ), $zones[3].blocks|count() )}
            {foreach $zones[3].blocks as $block}
            {if or( $block.valid_nodes|count(), 
                and( is_set( $block.custom_attributes), $block.custom_attributes|count() ), 
                and( eq( ezini( $block.type, 'ManualAddingOfItems', 'block.ini' ), 'disabled' ), ezini_hasvariable( $block.type, 'FetchClass', 'block.ini' )|not ) )}
                <div id="address-{$block.zone_id}-{$block.id}">
                {block_view_gui block=$block}
                </div>
            {/if}
            {/foreach}
            {/if}
        
        </div>
        </div>
        <div class="col-2">
        <div class="col-content">
    
            {if and( is_set( $zones[4].blocks ), $zones[4].blocks|count() )}
            {foreach $zones[4].blocks as $block}
            {if or( $block.valid_nodes|count(), 
                and( is_set( $block.custom_attributes), $block.custom_attributes|count() ), 
                and( eq( ezini( $block.type, 'ManualAddingOfItems', 'block.ini' ), 'disabled' ), ezini_hasvariable( $block.type, 'FetchClass', 'block.ini' )|not ) )}
                <div id="address-{$block.zone_id}-{$block.id}">
                {block_view_gui block=$block}
                </div>
            {/if}
            {/foreach}
            {/if}
        
        </div>
        </div>
        </div>
    
    {elseif and( is_set( $zones[3].blocks ), $zones[3].blocks|count() )}
    
        <div class="col-content">
            {if and( is_set( $zones[3].blocks ), $zones[3].blocks|count() )}
            {foreach $zones[3].blocks as $block}
            {if or( $block.valid_nodes|count(), 
                and( is_set( $block.custom_attributes), $block.custom_attributes|count() ), 
                and( eq( ezini( $block.type, 'ManualAddingOfItems', 'block.ini' ), 'disabled' ), ezini_hasvariable( $block.type, 'FetchClass', 'block.ini' )|not ) )}
                <div id="address-{$block.zone_id}-{$block.id}">
                {block_view_gui block=$block}
                </div>
            {/if}
            {/foreach}
            {/if}
        </div>
    
    {/if}
    
    
    </div>
    </div></div></div>
    <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
    </div>

{/if}

</div>