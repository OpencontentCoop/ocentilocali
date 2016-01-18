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

$options = $script->getOptions( "[node-id:]",
                                "",
                                array( 'node-id' => "Storage Node ID" )
                                );
$script->initialize();

if ( $options['node-id'] == NULL )
{
    $cli->error( 'Select a parent node' );
    $script->shutdown(); 
}
else
{
    $storageNode = $options['node-id'];
    $rootNode = eZContentObjectTreeNode::fetch( $storageNode )->attribute( 'parent_node_id' );
    
    $contentObjects = array();
    $db = eZDB::instance();
    
    $count = eZContentObjectTreeNode::subTreeCountByNodeID( array(), $storageNode );
    
    $cli->notice( "Number of objects to clean: $count" );
    
    $length = 50;
    $params = array( 'Offset' => 0 , 'Limit' => $length );
    
    $script->resetIteration( $count );
    
    $user = eZUser::fetchByName( 'admin' );
    if ( !$user )
    {
        $user = eZUser::currentUser();
    }
    eZUser::setCurrentlyLoggedInUser( $user, $user->attribute( 'contentobject_id' ) );

    do
    {
        //eZContentObject::clearCache();
        $nodes = eZContentObjectTreeNode::subTreeByNodeID( $params, $storageNode );
        
        foreach ( $nodes as $node )
        {            
            $nodeID = $node->attribute( 'node_id' );
            $cli->output( 'Processing node ' . $nodeID );
            $objectID = $node->attribute( 'contentobject_id' );
            $dataMap = $node->attribute( 'data_map' );

            if ( isset( $dataMap['data_iniziopubblicazione'] ) && $dataMap['data_iniziopubblicazione']->hasContent() )
            {
                $contentObject = $node->attribute( 'object' );
                $contentObject->setAttribute( 'published', $dataMap['data_iniziopubblicazione']->content()->timeStamp() );
                $contentObject->store();
            }                            
        }
            
        $params['Offset'] += $length;
    
    } while ( count( $nodes ) == $length );
}
$script->shutdown();
?>