#!/usr/bin/env php
<?php
set_time_limit ( 0 );
require 'autoload.php';

$siteINI = eZINI::instance();
$siteINI->setVariable( 'SearchSettings', 'DelayedIndexing', 'enabled' );

$cli = eZCLI::instance();
$script = eZScript::instance( array( 'description' => ( "Clean Storage" ),
                                      'use-session' => true,
                                      'use-modules' => true,                                      
                                      'use-extensions' => true ) );

$script->startup();

$options = $script->getOptions( "[nome:][descrizione:][endpoint:]",
                                "",
                                array( 'nome' => "Nome",
                                       'descrizione' => "Descrizione",
                                       'endpoint' => "EndPoint" )
                                );
$script->initialize();

try
{
    if ( !$options['nome'] )
    {
        throw new Exception( 'Inserisci il parametro nome' );
    }
    
    if ( !$options['descrizione'] )
    {
        throw new Exception( 'Inserisci il parametro descrizione' );
    }
    
    if ( !$options['endpoint'] )
    {
        throw new Exception( 'Inserisci il parametro endpoint' );
    }
    
    ezcBaseInit::setCallback( 'ezcInitPersistentSessionInstance', 'ezpRestPoConfig' );
    $session = ezcPersistentSessionInstance::get();
    
    $q = $session->createFindQuery( 'ezpRestClient' );
    $q->where( $q->expr->eq( 'name', $q->bindValue( $options['nome'] ) ) );
    $results = $session->find( $q, 'ezpRestClient' );
    
    if ( count( $results ) > 0 )
    {
        $application = array_shift( $results );
        eZCLI::instance()->output( $application->client_id );
        $script->shutdown();
    }
    else
    {
        $user = eZUser::currentUser();
        $application = new ezpRestClient();
        $application->name = ezpI18n::tr( 'extension/oauthadmin', 'New REST application' );
        $application->version = ezpRestClient::STATUS_DRAFT;
        $application->owner_id = $user->attribute( 'contentobject_id' );
        $application->created = time();
        $application->updated = 0;
        $application->version = ezpRestClient::STATUS_DRAFT;
        $session->save( $application );
        
        $application->name = $options['nome'];
        
        // generate id & secret
        if ( $application->version == ezpRestClient::STATUS_DRAFT )
        {
            $application->client_id = md5( $application->name . uniqid( $application->name ) );
            $application->client_secret = md5( $application->name . uniqid( $application->name ) );
        }
        $application->description = $options['descrizione'];
        $application->endpoint_uri = $options['endpoint'];
        $application->version = ezpRestClient::STATUS_PUBLISHED;
        $application->modified = time();
        $session->update( $application );
        
        eZCLI::instance()->output( $application->client_id );
        
        $script->shutdown();
    }
    
}
catch( Exception $e )
{    
    $errCode = $e->getCode();
    $errCode = $errCode != 0 ? $errCode : 1; // If an error has occured, script must terminate with a status other than 0
    $script->shutdown( $errCode, $e->getMessage() );
}