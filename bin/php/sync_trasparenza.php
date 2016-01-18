<?php
require 'autoload.php';

$script = eZScript::instance( array( 'description' => ( "OpenPA Sincronizzazione Amministrazione Tasparente\n\n" ),
                                     'use-session' => false,
                                     'use-modules' => true,
                                     'use-extensions' => true ) );

$script->startup();

$options = $script->getOptions();

$createMissing = true;

$script->initialize();
$script->setUseDebugAccumulators( true );
try
{
    $user = eZUser::fetchByName( 'admin' );
    eZUser::setCurrentlyLoggedInUser( $user , $user->attribute( 'contentobject_id' ) );
    
    $siteaccess = eZSiteAccess::current();
    if ( stripos( $siteaccess['name'], 'prototipo' ) !== false )
    {
        throw new Exception( 'Script non eseguibile sul prototipo' );        
    }
        
    $localRemoteIdPrefix = OpenPABase::getCurrentSiteaccessIdentifier();    
     
    // sincronizzazaione classi
    $classiTrasparenza = array(
        //'conferimento_incarico',
        //'consulenza',
        'nota_trasparenza',
        'pagina_trasparenza',
        //'responsabile_trasparenza',
        'trasparenza',
        //'tasso_assenza',
        //'dipendente',
        //'incarico',
        //'sovvenzione_contributo',
        //'organo_politico'
    );
    
    foreach( $classiTrasparenza as $identifier )
    {
        OpenPALog::warning( 'Sincronizzo classe ' . $identifier );
        $tools = new OpenPAClassTools( $identifier, true ); // creo se non esiste
        $tools->sync( true, true ); // forzo e rimuovo attributi in più
    }
   
    //@todo mettere in un openpa.ini
    $treeNode = 'http://openpa.opencontent.it/api/opendata/v1/content/node/966';
    $treeUrl = $treeNode . '/list/offset/0/limit/1000';
    
    $apiNode = OpenPAApiNode::fromLink( $treeNode );
    $localRoot = $apiNode->searchLocal( false );
    OpenPAObjectTools::syncObjectFormRemoteApiNode( $apiNode, $localRoot, $localRemoteIdPrefix );    
    $dataTree = json_decode( OpenPABase::getDataByURL( $treeUrl ), true );
    if ( $dataTree )
    {
        foreach( $dataTree['childrenNodes'] as $item )
        {
            $item = new OpenPAApiChildNode( $item );
            $apiNode = $item->getApiNode();
            try
            {                
                $parentNodeId = $localRoot->attribute( 'main_node' )->attribute( 'node_id');
                $local = $apiNode->searchLocal( false, $parentNodeId );
                OpenPALog::notice( '|-- ', false );
                if ( $local )
                {                    
                    OpenPAObjectTools::syncObjectFormRemoteApiNode( $apiNode, $local, $localRemoteIdPrefix );
                    foreach( $item->getChildren() as $child )
                    {
                        if ( $child->classIdentifier == 'pagina_trasparenza' )
                        {
                            OpenPALog::notice( '  |-- ', false );
                            $apiNodeChild = $child->getApiNode();
                            $childParentNodeId = $local->attribute( 'main_node' )->attribute( 'node_id');
                            $localChild = $apiNodeChild->searchLocal( false, $childParentNodeId );
                            if ( $localChild )
                            {
                                OpenPAObjectTools::syncObjectFormRemoteApiNode( $apiNodeChild, $localChild, $localRemoteIdPrefix );
                                foreach( $child->getChildren() as $subchild )
                                {
                                    if ( $subchild->classIdentifier == 'pagina_trasparenza' )
                                    {
                                        OpenPALog::notice( '  |-- ', false );
                                        $apiNodeSubChild = $subchild->getApiNode();
                                        $subchildParentNodeId = $localChild->attribute( 'main_node' )->attribute( 'node_id');
                                        $localSubChild = $apiNodeSubChild->searchLocal( false, $childParentNodeId );
                                        if ( $localSubChild )
                                        {
                                            OpenPAObjectTools::syncObjectFormRemoteApiNode( $apiNodeSubChild, $localSubChild, $localRemoteIdPrefix );
                                        }
                                        else
                                        {
                                            OpenPALog::notice( $apiNodeSubChild->metadata['objectName'] . ' (' . $apiNodeSubChild->metadata['objectRemoteId'] . ')', false );
                                            $apiNodeSubChild->createContentObject( $subchildParentNodeId, $localRemoteIdPrefix );
                                            OpenPALog::notice( ' ...creato' );                    
                                        }        
                                        
                                    }
                                }
                            }
                            elseif ( $createMissing )
                            {
                                OpenPALog::notice( $apiNodeChild->metadata['objectName'] . ' (' . $apiNodeChild->metadata['objectRemoteId'] . ')', false );
                                //$apiNodeChild->createContentObject( $childParentNodeId, $localRemoteIdPrefix );
                                OpenPALog::notice( ' ...creato' );                    
                            }
                            else
                            {
                                OpenPALog::error( $apiNodeChild->metadata['objectName'] . ' (' . $apiNodeChild->metadata['objectRemoteId'] . ') ...non trovato' );
                            }
                            
                        }
                    }
                }
                elseif ( $createMissing )
                {
                    OpenPALog::notice( $apiNode->metadata['objectName'] . ' (' . $apiNode->metadata['objectRemoteId'] . ')', false );
                    //$apiNode->createContentObject( $parentNodeId, $localRemoteIdPrefix );
                    OpenPALog::notice( ' ...creato' );                    
                }
                else
                {
                    OpenPALog::error( $apiNode->metadata['objectName'] . ' (' . $apiNode->metadata['objectRemoteId'] . ') ...non trovato' );
                }
            }
            catch( Exception $e )
            {
                OpenPALog::error( $item->objectName . ': ' . $e->getMessage() );
            }
        }
    }
    
    $script->shutdown();
}
catch( Exception $e )
{
    $errCode = $e->getCode();
    $errCode = $errCode != 0 ? $errCode : 1; // If an error has occured, script must terminate with a status other than 0
    $script->shutdown( $errCode, $e->getMessage() );
}
