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

$options = $script->getOptions( "[node-id:][from-node-id:]",
                                "",
                                array( 'node-id' => "Storage Node ID", 'from-node-id' => "Parent Node ID" )
                                );
$script->initialize();

function addLocationsAndRemoveOthers( $node, $selectedNodeIDArray, $cli )
{
    $db = eZDB::instance();
    $db->begin();
    $nodeID = $node->attribute( 'node_id' );
    $objectID = $node->attribute( 'contentobject_id' );
    if ( !empty( $selectedNodeIDArray ) )
    {
         $cli->output( ' Adding locations ' . implode( ', ', $selectedNodeIDArray ) . ' for object ' . $objectID, false );
         $operationResult = eZOperationHandler::execute( 'content',
                                                         'addlocation', array( 'node_id'              => $nodeID,
                                                                               'object_id'            => $objectID,
                                                                               'select_node_id_array' => $selectedNodeIDArray ),
                                                         null,
                                                         true );
    }
    
    $assignedNodes = $node->attribute( 'object' )->attribute( 'assigned_nodes' );
    $removeList = array();
    foreach( $assignedNodes as $assignedNode )
    {
        $pathArray = $assignedNode->attribute( 'path_array' );
        $diff = array_intersect( $selectedNodeIDArray, $pathArray );
        if ( empty( $diff ) )
        {
            $removeList[] = $assignedNode->attribute( 'node_id' );
        }
    }
    
    if ( !empty( $removeList ) )
    {
        $cli->output( ' Removing locations ' . implode( ', ', $removeList ) . ' for object ' . $objectID, false );
        $operationResult = eZOperationHandler::execute( 'content',
                                                        'removelocation', array( 'node_list' => $removeList ),
                                                        null,
                                                        true );   
    }
    $db->commit();
}


/*if ( class_exists( 'SQLIImportToken' ) && SQLIImportToken::importIsRunning() )
{
    $cli->error( 'A sqliimport is running. Aborting...' );
    $script->shutdown();
}
elseif ( class_exists( 'SQLIImportToken' ) )
{
    SQLIImportToken::registerNewImport();
}
*/
if ( $options['node-id'] == NULL || $options['from-node-id'] == NULL )
{
    $cli->error( 'Select a storage and a from node' );
}
else
{
    $user = eZUser::fetchByName( 'admin' );
    if ( !$user )
    {
        $user = eZUser::currentUser();
    }
    eZUser::setCurrentlyLoggedInUser( $user, $user->attribute( 'contentobject_id' ) );
    
    $storageNode = $options['node-id'];
    $parentNode = $options['from-node-id'];
    $rootNode = eZContentObjectTreeNode::fetch( $parentNode )->attribute( 'parent_node_id' );
    
    $contentObjects = array();    
    
    $count = eZContentObjectTreeNode::subTreeCountByNodeID( array(), $parentNode );
    
    $cli->notice( "Number of objects to move: $count" );
    
    $length = 100;
    $params = array( 'Offset' => 0 , 'Limit' => $length, 'SortBy' => array( 'contentobject_id', true ) );
    
    $script->resetIteration( $count );
    
    do
    {
        //eZContentObject::clearCache();
        $nodes = eZContentObjectTreeNode::subTreeByNodeID( $params, $parentNode );
        
        foreach ( $nodes as $node )
        {            
            $nodeID = $node->attribute( 'node_id' );
            $cli->output( 'Processing node ' . $nodeID, false );                                    
            addLocationsAndRemoveOthers( $node, array( $storageNode ), $cli );            
            $cli->output();
        }
            
        $params['Offset'] += $length;
    
    } while ( count( $nodes ) == $length );
}

/*if ( class_exists( 'SQLIImportToken' ) )
{
    SQLIImportToken::cleanAll();
}
*/
$script->shutdown();
?>
