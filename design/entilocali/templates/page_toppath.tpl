{if openpacontext().is_area_tematica}
    {if openpacontext().area_tematica_cover_image}
        <div class="immagine-area-tematica">
            <div class="header_area_tematica">
                <img src="{openpacontext().area_tematica_cover_image}" />
            </div>
        </div>
    {elseif openpacontext().area_tematica_image}
        <div class="immagine-area-tematica">
            <div class="header_area_tematica">
                <img src="{openpacontext().area_tematica_image}" />
            </div>
        </div>
    {/if}
{/if}
<div id="path-wrapper">
    <div id="path" class="width-layout">
        {include uri='design:parts/path.tpl'}
    </div>
</div>