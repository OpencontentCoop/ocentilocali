#!/usr/bin/env php
<?php
set_time_limit ( 0 );
require 'autoload.php';

$siteINI = eZINI::instance();
$siteINI->setVariable( 'ContentSettings', 'ViewCaching', 'disabled' );
$siteINI->setVariable( 'SearchSettings', 'DelayedIndexing', 'enabled' );

function addPending( $contentObjectId )
{
    $rowPending = array(
        'action'        => SQLIContent::ACTION_CLEAR_CACHE,        
        'param'         => $contentObjectId
    );
    
    $pendingItem = new eZPendingActions( $rowPending );
    $pendingItem->store();
}

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

function addLocationsAndRemoveOthers( $node, $selectedNodeIDArray, $cli )
{
    if ( empty( $selectedNodeIDArray ) )
    {
        $cli->output( ' error: empty destination nodes', false );
        return;
    }
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
    addPending( $objectID );
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
if ( $options['node-id'] == NULL )
{
    $cli->error( 'Select a storage node' );
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

    $rootNode = eZContentObjectTreeNode::fetch( $storageNode )->attribute( 'parent_node_id' );
    
    $contentObjects = array();    
    
    $count = eZContentObjectTreeNode::subTreeCountByNodeID( array(), $storageNode );
    
    $cli->warning( "Number of objects to clean: $count" );
    sleep( 2 );
    
    $length = 100;
    $params = array( 'Offset' => 0 , 'Limit' => $length, 'SortBy' => array( 'contentobject_id', true ) );
    
    $script->resetIteration( $count );
    
    $INILocationsPerClasses = eZINI::instance( 'entilocali.ini' )->hasVariable( 'LocationsPerClasses', 'Storage_' . $storageNode ) ? eZINI::instance( 'entilocali.ini' )->variable( 'LocationsPerClasses', 'Storage_' . $storageNode ) : false;

    if( $INILocationsPerClasses === false )
    {
        eZLog::write( "Mancano le impostazioni di 'LocationsPerClasses' per 'Storage_$storageNode' in entilocali.ini!", 'error.log' );
    }

    do
    {
        //eZContentObject::clearCache();
        $nodes = eZContentObjectTreeNode::subTreeByNodeID( $params, $storageNode );
        
        foreach ( $nodes as $node )
        {            
            $nodeID = $node->attribute( 'node_id' );
            $cli->output( 'Processing node ' . $nodeID, false );            
            $objectID = $node->attribute( 'contentobject_id' );
            $dataMap = $node->attribute( 'data_map' );
         
            if ( isset( $dataMap['comune'] ) && $dataMap['comune']->hasContent() )
            {
                $comuni = $dataMap['comune']->content();
                
                $selectedNodeIDArray = array();
                
                foreach( $comuni['relation_list']  as $key => $comune )
                {
                    $comune = eZContentObject::fetch( $comune['contentobject_id'] );
                    if ( $comune )
                    {
                        $assigned_nodes = $comune->attribute( 'assigned_nodes' );
                        foreach( $assigned_nodes as $assigned_node )
                        {
                            $pathArray = $assigned_node->attribute( 'path_array' );
                            if ( in_array( $rootNode, $pathArray ) )
                            {
                                $selectedNodeIDArray[] = $assigned_node->attribute( 'node_id' );
                            }
                        }
                    }
                }                
                
                addLocationsAndRemoveOthers( $node, $selectedNodeIDArray, $cli );
                
            }
            elseif ( $INILocationsPerClasses )
            {
                $locations = $INILocationsPerClasses;
                $locationPerClasses = array();
                foreach( $locations as $classAndNode )
                {
                    $classAndNode = explode( ';', $classAndNode );
                    $classes = explode( ',', $classAndNode[0] );
                    $location = $classAndNode[1];
                    $locationPerClasses[$location] = $classes;
                }
                
                if ( !empty( $locationPerClasses ) )
                {
                    foreach( $locationPerClasses as $location => $classes )
                    {
                        if ( in_array( $node->attribute( 'class_identifier' ), $classes ) )
                        {
                            if ( !eZContentObjectTreeNode::fetch( $location ) )
                            {
                                $cli->error( "Il nodo $location non esiste!" );
                            }
                            else
                            {
                                addLocationsAndRemoveOthers( $node, array( $location ), $cli );
                            }
                        }
                    }
                }
            }
            
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

SQLIImportUtils::viewCacheClear();

$script->shutdown();
?>
