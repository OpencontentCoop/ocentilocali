{include name=menu_control node=$node uri='design:parts/common/menu_control.tpl'}

<div class="content-view-full">
    <div class="class-frontpage">

    {if $node.data_map.page.has_content}

        <div class="attribute-page">
        {attribute_view_gui attribute=$node.object.data_map.page}
        </div>
    
    {else}
    
        <div class="attribute-header">
            <h1>{$node.name|wash()}</h1>
        </div>
        
        {if $node|has_abstract()}
        <div class="attributi-principali float-break col">
            <div class="col-content-design float-break">
                {$node|abstract()}
            </div>
        </div>
        {/if}
    
        {if $node.children_count|gt(0)}
        <div class="content-view-children">
            {def $style='col-odd'}
            {foreach $node.children as $child }
                {if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
                <div class="{$style} col float-break col-notitle">
                <div class="col-content"><div class="col-content-design">
                    {node_view_gui view='line' content_node=$child}
                </div></div>
                </div>
            {/foreach}
        </div>
        {/if}
    
    {/if}

    </div>
</div>