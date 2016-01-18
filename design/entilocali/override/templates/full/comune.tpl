{include name=menu_control node=$node uri='design:parts/common/menu_control.tpl'}
{def $links = cond( ezini_hasvariable( 'MenuComune', 'Item', 'entilocali.ini' ), ezini( 'MenuComune', 'Item', 'entilocali.ini' ), array() )
     $currentlink = false()
     $classes = array()
     $tpl = false()
     $nullText = 'Nessun elemento pubblicato'}
{if is_set( $view_parameters.show )}
    {foreach $links as $name => $url}
        {if $url|eq( concat( '/(show)/', $view_parameters.show ) )}
            {set $currentlink = $name}
            {if ezini_hasvariable( $view_parameters.show, 'Classes', 'entilocali.ini' )}
                {set $classes = ezini( $view_parameters.show, 'Classes', 'entilocali.ini' )}
            {/if}
            {if ezini_hasvariable( $view_parameters.show, 'Template', 'entilocali.ini' )}
                {set $tpl = ezini( $view_parameters.show, 'Template', 'entilocali.ini' )}
            {/if}
            {if ezini_hasvariable( $view_parameters.show, 'NullText', 'entilocali.ini' )}
                {set $nullText = ezini( $view_parameters.show, 'NullText', 'entilocali.ini' )}
            {/if}
            {break}
        {/if}
    {/foreach}
{/if}

{def $display = false()}
{if is_set( $view_parameters.display )}
    {set $display = $view_parameters.display}
{/if}

{def $pagestyle = 'norightcol-comune'}
{if $links|count()|eq(0)}
    {ezpagedata_set( 'left_menu', false() )}
    {set $pagestyle = concat( $pagestyle, ' noleftcol-comune' )}
{/if}

<div class="border-box">
<div class="border-content">

 <div class="global-view-full content-view-full">
  <div class="class-{$node.object.class_identifier}">

    <div class="columns-comune float-break {$pagestyle}">
        {if count( $links )|gt(0) }
        <div class="sidemenu-column-position">
            <div id="sidemenu">
                <ul class="menu-list">
                    {foreach $links as $name => $url}
                        <li>
                            <div class="second_level_menu">
                                <span class="handler{if $currentlink|eq($name)} selected current{/if}"></span>
                                <a {if $currentlink|eq($name)}class="selected{if $display|not()} current{/if}"{/if} title="Visualizza {$name} del comune di {$node.name|wash()}" href="{concat( $node.url, $url )|ezurl(no)}">
                                    <span>{$name|wash()}</span>
                                </a>
                            </div>
                            
                            {if and( ezini_hasvariable( $url|explode('/(show)/')|implode(''), 'Submenu', 'entilocali.ini' ), ezini( $url|explode('/(show)/')|implode(''), 'Submenu', 'entilocali.ini' )|eq( 'enabled' ) )}
                                <ul class="submenu-list">
                                    {foreach ezini( $url|explode('/(show)/')|implode(''), 'Classes', 'entilocali.ini' ) as $index => $class}
                                        {if fetch( 'content', 'tree_count', hash( 'parent_node_id', $node.node_id, 'class_filter_type', 'include', 'class_filter_array', array( $class ) ) )}
                                        <li>
                                            <div class="third_level_menu">
                                                <span class="handler"></span>
                                                <a {if $display|eq( $class )} class="selected current"{/if} href="{concat( $node.url, $url, '/(display)/', $class )|ezurl(no)}">
                                                    <span>{$index|wash()}</span>
                                                </a>
                                            </div>
                                        </li>
                                        {/if}
                                    {/foreach}
                                </ul>
                            {/if}
                            
                        </li>
                    {/foreach}
                </ul>
            </div>
        </div>
        {/if}
        <div class="main-column-position">
            <div class="main-column float-break">
                
                {if $currentlink}
                    <h1><a href={$node.url|ezurl()}>{$node.name|wash()}</a> - {$currentlink|wash()}</h1>
                {else}
                    <h1>{$node.name|wash()}</h1>
                {/if}
                
                {if $currentlink}
                    {if $tpl}
                        {include uri=concat( 'design:comune/', $tpl) node=$node view_parameters=$view_parameters}
                    {elseif $classes|count|gt(0)}
                        {if $display}
                            {set $classes = array( $display )}
                        {/if}
                        {def $page_limit = 10
                             $style = 'col-odd'
                             $children_count = fetch( 'content', 'tree_count', hash( 'parent_node_id', $node.node_id,
                                                              'class_filter_type', 'include',
                                                              'class_filter_array', $classes ) )
                             $children = fetch( 'content', 'tree', hash( 'parent_node_id', $node.node_id,
                                                              'offset', $view_parameters.offset,
                                                              'sort_by', array( 'published', false() ),
                                                              'class_filter_type', 'include',
                                                              'class_filter_array', $classes,
                                                              'limit', $page_limit ) )}
                        {if $children_count}
                            {set $style='col-odd'}
                            {foreach $children as $child }
                                {if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
                                <div class="{$style} col float-break col-notitle">
                                    <div class="col-content"><div class="col-content-design">
                                        {node_view_gui view='line' content_node=$child}
                                    </div></div>
                                </div>
                            {/foreach}
                            
                            {include name=navigator
                                    uri='design:navigator/google.tpl'
                                    page_uri=$node.url_alias
                                    item_count=$children_count
                                    view_parameters=$view_parameters
                                    item_limit=$page_limit}
                            
                        {else}
                            <p>{$nullText}</p>
                        {/if}
                    {/if}
                {else}
                
                    <div class="attributi-principali float-break col col-notitle">
                    <div class="col-content"><div class="col-content-design">
                        <div class="object-left">
                        {if is_set($node.data_map.stemma)}
                            {if $node.data_map.stemma.has_content}
                                {attribute_view_gui attribute=$node.data_map.stemma image_class='medium'}
                            {/if}
                        {/if}
                        </div>
                            {if and( is_set( $node.data_map.abstract ), $node.data_map.abstract.has_content )}
                                {attribute_view_gui attribute=$node.data_map.abstract}
                            {/if}
                    </div></div>
                    </div>

                    <div class="attributi-base">
                    {def $style='col-odd'
                         $attributi_da_escludere = ezini( 'GestioneAttributi', 'attributi_da_escludere', 'openpa.ini')|append('abstract')
                         $attributi_da_evidenziare = ezini( 'GestioneAttributi', 'attributi_da_evidenziare', 'openpa.ini')
                         $attributi_a_destra = ezini( 'GestioneAttributi', 'attributi_a_destra', 'openpa.ini')
                         $attributi_allegati_atti = ezini( 'GestioneAttributi', 'attributi_allegati_atti', 'openpa.ini')
                         $attributi_senza_link = ezini( 'GestioneAttributi', 'attributi_senza_link', 'openpa.ini')
                         $oggetti_senza_label = ezini( 'GestioneAttributi', 'oggetti_senza_label', 'openpa.ini')}
                         
                    {foreach $node.object.contentobject_attributes as $attribute}
                        {if and( $attribute.has_content, $attribute.content|ne('0') )}
                            {if $attributi_da_escludere|contains( $attribute.contentclass_attribute_identifier )|not()}
                                {if $style|eq( 'col-even' )}{set $style = 'col-odd'}{else}{set $style = 'col-even'}{/if}
                                {if $oggetti_senza_label|contains( $attribute.contentclass_attribute_identifier )|not()}
                                   <div class="{$style} col float-break attribute-{$attribute.contentclass_attribute_identifier}">
                                        <div class="col-title"><span class="label">{$attribute.contentclass_attribute_name}</span></div>
                                        <div class="col-content"><div class="col-content-design">
                                            {if $attributi_senza_link|contains( $attribute.contentclass_attribute_identifier )}
                                                {attribute_view_gui href='nolink' attribute=$attribute}
                                            {else}
                                                {attribute_view_gui attribute=$attribute}
                                            {/if}
                                        </div></div>
                                   </div>
                                {else}
                                   <div class="{$style} col col-notitle float-break attribute-{$attribute.contentclass_attribute_identifier}">
                                    <div class="col-content"><div class="col-content-design">
                                        {if $attributi_senza_link|contains( $attribute.contentclass_attribute_identifier )}
                                            {attribute_view_gui href='nolink' is_area_tematica=$is_area_tematica attribute=$attribute}
                                        {else}
                                            {attribute_view_gui is_area_tematica=$is_area_tematica attribute=$attribute}
                                        {/if}
                                    </div></div>
                                   </div>
                                {/if}
                            {/if} 
                        {else}
                            {if $attribute.contentclass_attribute_identifier|eq('ezflowmedia')}
                                {if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
                                    <div class="{$style} col float-break attribute-fullbase-{$attribute.contentclass_attribute_identifier} {if $oggetti_senza_label|contains($attribute.contentclass_attribute_identifier)}col-notitle{/if}">
                                        <div class="col-content"><div class="col-content-design">
                                        {attribute_view_gui is_area_tematica=$is_area_tematica attribute=$attribute}
                                        </div></div>
                                    </div>
                            {/if}		
                        {/if}
                    {/foreach}
                    </div>
                    
                {/if}
                
            </div>
        </div>
        <div class="extrainfo-column-position">
            <div class="extrainfo-column">
            </div>
        </div>
    </div>

  </div>
 </div>

</div>
</div>