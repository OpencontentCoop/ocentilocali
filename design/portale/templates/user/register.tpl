<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="user-login user-register">

<form enctype="multipart/form-data"  action={"/user/register/"|ezurl} method="post" name="Register">

<div class="attribute-header">
    <h1 class="long">Iscriviti al portale del territorio</h1>
</div>

{if $validation.processed}

    {if $validation.attributes|count|gt(0)}
        <div class="warning abs">                
        {foreach $validation.attributes as $attribute}
            {$attribute.name}: {$attribute.description}
            {delimiter}<br />{/delimiter}
        {/foreach}        
        </div>    
    {/if}

{/if}

{def $attribute_base='ContentObjectAttribute'
     $first_name = false()
     $last_name = false()
     $user_account = false()}

{if count($content_attributes)|gt(0)}
    
    {foreach $content_attributes as $attribute}
    {if $attribute.contentclass_attribute.identifier|eq('first_name')}
        {set $first_name = $attribute}
    {elseif $attribute.contentclass_attribute.identifier|eq('last_name')}
        {set $last_name = $attribute}
    {elseif $attribute.contentclass_attribute.identifier|eq('user_account')}
        {set $user_account = $attribute}
    {/if}    
    {/foreach}
    
    <div class="block">
    
        {def $error = false()}
        <div class="element">    
            {* Nome *}
            {*if $validation.processed}
                {foreach $validation.attributes as $validation_attribute}
                {if $validation_attribute.name|eq($first_name.contentclass_attribute.name)}
                    {set $error = true()}
                    <div class="warning"><small>{$validation_attribute.description}</small></div>
                {/if}
                {/foreach}
            {/if*}
            <input type="hidden" name="ContentObjectAttribute_id[]" value="{$first_name.id}" />
            <input placeholder="{$first_name.contentclass_attribute.name|wash}" class="halfbox {if $error}error{/if}" type="text" size="25" name="{$attribute_base}_ezstring_data_text_{$first_name.id}" value="{$first_name.data_text|wash( xhtml )}" />
        </div>
        
        {set $error = false()}
        <div class="element">   
            {* Cognome *}
            {*if $validation.processed}
                {foreach $validation.attributes as $validation_attribute}
                {if $validation_attribute.name|eq($last_name.contentclass_attribute.name)}
                    {set $error = true()}
                    <div class="warning"><small>{$validation_attribute.description}</small></div>
                {/if}
                {/foreach}
            {/if*}
            <input type="hidden" name="ContentObjectAttribute_id[]" value="{$last_name.id}" />
            <input placeholder="{$last_name.contentclass_attribute.name|wash}" class="halfbox {if $error}error{/if}" type="text" size="25" name="{$attribute_base}_ezstring_data_text_{$last_name.id}" value="{$last_name.data_text|wash( xhtml )}" />
        </div>
    
    </div>
        
    {set $error = false()}
    {*if $validation.processed}
        {foreach $validation.attributes as $validation_attribute}
        {if $validation_attribute.name|eq($user_account.contentclass_attribute.name)}
            {set $error = true()}
            <div class="warning"><small>{$validation_attribute.description}</small></div>
        {/if}
        {/foreach}
    {/if*}
    
    <div class="block">        
        <div class="element">    
            {* Username. *}
            <input type="hidden" name="ContentObjectAttribute_id[]" value="{$user_account.id}" />        
            <input placeholder="Nome utente" id="login" class="halfbox" type="text" name="{$attribute_base}_data_user_login_{$user_account.id}" size="25" value="{$user_account.content.login}" />
        </div>
        
        <div class="element">
            {* Email. *}            
            <input placeholder="Email"  id="email" class="halfbox" type="text" name="{$attribute_base}_data_user_email_{$user_account.id}" size="25" value="{$user_account.content.email|wash( xhtml )}" />            
        </div>
    
    </div>
    
    <div class="block">

        <div class="element"> 
            {* Password #1. *}            
            <input placeholder="Password" id="password" class="halfbox" type="password" name="{$attribute_base}_data_user_password_{$user_account.id}" size="25" value="" />
        </div>

        <div class="element"> 
            {* Password #2. *}    
            <input placeholder="Ripeti password"  id="password_confirm" class="halfbox" type="password" name="{$attribute_base}_data_user_password_confirm_{$user_account.id}" size="25" value="" />
        </div>
    
    </div>



    <div class="buttonblock">
        <input class="button" type="hidden" name="UserID" value="{$content_attributes[0].contentobject_id}" />    
        <input class="defaultbutton" type="submit" id="PublishButton" name="PublishButton" value="{'Register'|i18n('design/ezwebin/user/register')}" />
        {*<input class="button" type="submit" id="CancelButton" name="CancelButton" value="{'Back'|i18n('design/ezwebin/user/register')}" />*}
        <input class="button" type="button" id="CancelButton" name="CancelButton" value="{'Back'|i18n('design/ezwebin/user/register')}" onclick="history.go(-1);" />        
    </div>
{/if}
</form>

</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
