<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<form action={concat($module.functions.edit.uri,"/",$userID)|ezurl} method="post" name="Edit">

<div class="user-edit">

<div class="attribute-header">
  <h1 class="long">Ciao {$userAccount.contentobject.name|wash}</h1>
</div>

<div class="block">
  <label>{"Username"|i18n("design/ezwebin/user/edit")}</label><div class="labelbreak"></div>
  <p class="box">{$userAccount.login|wash}</p>
</div>

<div class="block">
  <label>{"Email"|i18n("design/ezwebin/user/edit")}</label><div class="labelbreak"></div>
  <p class="box">{$userAccount.email|wash(email)}</p>
</div>

<div class="block">
  <label>{"Name"|i18n("design/ezwebin/user/edit")}</label><div class="labelbreak"></div>
  <p class="box">{$userAccount.contentobject.name|wash}</p>
</div>

{if fetch( 'user', 'has_access_to', hash( 'module', 'notification',
                                          'function', 'use' ) )}
<p><a href={"notification/settings"|ezurl}>{"My notification settings"|i18n("design/ezwebin/user/edit")}</a></p>
{/if}

{def $authApps = $userAccount|authorized_apps()}
{if count($authApps)|gt(0)}
    <div class="block">
        <label>Applicazioni autorizzate</label><div class="labelbreak"></div>
        <ul>
    {foreach $authApps as $app}        
        <li class="box"><strong>{$app.site}</strong> - {$app.name} {$app.description}</li>
    {/foreach}
        </ul>
    </div>
{/if}

<div class="buttonblock">
<input class="button" type="submit" name="EditButton" value="{'Edit profile'|i18n('design/ezwebin/user/edit')}" />
<input class="button" type="submit" name="ChangePasswordButton" value="{'Change password'|i18n('design/ezwebin/user/edit')}" />
</div>

</div>

</form>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>