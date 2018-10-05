{if is_set($module_result.content_info.persistent_variable.has_container)|not()}
<div id="columns-position" class="width-layout">
    <div class="columns-ml"><div class="columns-mr"><div class="columns-mc">
    <div class="columns-content">
    <div id="columns" class="float-break">
        {include uri='design:page_searchbox.tpl'}
        <div id="main-position">
            <div id="main" class="float-break">
                <div class="overflow-fix">
{/if}

                    {$module_result.content}

{if is_set($module_result.content_info.persistent_variable.has_container)|not()}
                </div>
            </div>
        </div>
    </div>
    </div>
    </div></div></div>
    <div class="columns-bl"><div class="columns-br"><div class="columns-bc"></div></div></div>
</div>
{/if}