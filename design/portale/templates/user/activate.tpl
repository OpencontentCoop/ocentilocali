<div class="message-feedback">
{if $account_activated}
    
    <h2>{"Activate account"|i18n("design/standard/user")}</h2>
    
    {if $is_pending}
        <p>{'Your email address has been confirmed. An administrator needs to approve your sign up request, before your login becomes valid.'|i18n('design/standard/user')}</p>
    {else}
        <p>{'Your account is now activated.'|i18n('design/standard/user')}</p>
    {/if}
        
    {if ezhttp_hasvariable( 'redirect', 'get' )}
        <h2 class="text-center"><a href={ezhttp( 'redirect', 'get' )}>Procedi</a></h2>
    {else}        
        <form action={"/"|ezurl} method="post">
            <input class="button" type="submit" value="{'OK'|i18n( 'design/standard/user' )}" />
        </form>        
    {/if}
    
{elseif $already_active}
    <h1>{'Your account is already active.'|i18n('design/standard/user')}</h1>

{else}
    <p>{'Sorry, the key submitted was not a valid key. Account was not activated.'|i18n('design/standard/user')}</p>

{/if}

</div>