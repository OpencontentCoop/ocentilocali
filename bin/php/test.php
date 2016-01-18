<?php
require 'autoload.php';

$script = eZScript::instance( array( 'description' => ( "Test" ),
                                     'use-session' => false,
                                     'use-modules' => true,
                                     'use-extensions' => true ) );

$script->startup();

$options = $script->getOptions();
$script->initialize();
$script->setUseDebugAccumulators( true );

OpenPALog::setOutputLevel( OpenPALog::ALL );




try
{
    $conds = array( 'action' => SQLIContent::ACTION_CLEAR_CACHE );
    print_r(eZPendingActions::fetchObjectList( eZPendingActions::definition(), null, $conds, null ));
    
    $script->shutdown();
}
catch( Exception $e )
{    
    $errCode = $e->getCode();
    $errCode = $errCode != 0 ? $errCode : 1; // If an error has occured, script must terminate with a status other than 0
    $script->shutdown( $errCode, $e->getMessage() );
}