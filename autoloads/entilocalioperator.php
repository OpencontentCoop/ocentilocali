<?php

class EntilocaliOperator
{
    
    public $nodes = array();
    
    private $ini;
    
    private $tpl;
    
    function EntilocaliOperator()
    {
        $this->Operators= self::Operators();
        $this->ini = eZINI::instance( 'entilocali.ini' );
    }

    public static function Operators()
    {
        return array( 'entelocale_node', 'entelocale_background', 'entelocale_info', 'autofont', 'is_comune', 'is_comuni_folder', 'unit_measure', 'is_in_subsite', 'authorized_apps', 'siteaccess_identifier' );
    }
    
    function operatorList()
    {
        return $this->Operators;
    }

    function namedParameterPerOperator()
    {
        return true;
    }

    function namedParameterList()
    {
        return array(                        
            'autofont' => array
            (
                'identifier' => array( "type" => "string", "required" => false, "default" => "default" )
            )
        );
    }
    
    function isNodeInCurrentSiteaccess( $node )
    {
        if ( !$node instanceof eZContentObjectTreeNode )
        {
            return true;
        }
        $currentSiteaccess = eZSiteAccess::current();
        $pathPrefixExclude = eZINI::instance()->variable( 'SiteAccessSettings', 'PathPrefixExclude' );
        $aliasArray = explode( '/', $node->attribute( 'url_alias' ) );
        
        //eZDebug::writeError( var_export($aliasArray,1), __METHOD__ );
        //eZDebug::writeError( $pathPrefixExclude, __METHOD__ );
        
        foreach( $pathPrefixExclude as $ppe )
        {
            if ( strtolower( $aliasArray[0] ) == $ppe )
            {
                return true;
            }
        }
        
        $pathArray = $node->attribute( 'path_array' );
        $contentIni = eZINI::instance( 'content.ini' );
        $rootNodeArray = array(
            'RootNode',
            'UserRootNode',
            'MediaRootNode'                
        );
        
        foreach ( $rootNodeArray as $rootNodeID )
        {
            $rootNode = $contentIni->variable( 'NodeSettings', $rootNodeID );
            if ( in_array( $rootNode, $pathArray ) ) {
                return true;
            }
        }
        eZDebug::writeError( 'Relazione errata ' . $node->attribute( 'name' ), __METHOD__ );
        return false;
    }
    
    private function removeRelatedObjectItem( $contentObjectAttribute, $objectID )
    {
        $toString = $contentObjectAttribute->toString();
        $array = explode( '-', $toString );
        foreach( $array as $key => $item )
        {
            if ( $item == $objectID )
            {
                unset( $array[$key] );
            }
        }
        $contentObjectAttribute->fromString( implode( '-', $array ) );
        $contentObjectAttribute->store();
        return $return;
    }
    
    function modify( &$tpl, &$operatorName, &$operatorParameters, &$rootNamespace, &$currentNamespace, &$operatorValue, &$namedParameters )
    {		        
        $this->tpl = $tpl;
        $this->nodes = $this->nodes();
        
        switch ( $operatorName )
        {                        
            case 'siteaccess_identifier':
            {
                return $operatorValue = OpenPABase::getCurrentSiteaccessIdentifier();
            } break;
            
            //workaround per gli oggetti correlati che puntano erroneamente in altre comunità
            case 'is_in_subsite':
            {
                if ( $operatorValue instanceof eZContentObject )
                {
                    $nodes = $operatorValue->attribute( 'assigned_nodes' );
                    foreach( $nodes as $node )
                    {
                        if ( $this->isNodeInCurrentSiteaccess( $node ) )
                        {
                            return $operatorValue;
                        }
                    }
                }
                elseif( $operatorValue instanceof eZContentObjectTreeNode )
                {
                    if ( $this->isNodeInCurrentSiteaccess( $operatorValue ) )
                    {
                        return $operatorValue;
                    }
                }
                return $operatorValue = false;
            }
            case 'unit_measure':
            {
                $string = $operatorValue;
                if ( strpos( $string, 'px' ) == false
                     && strpos( $string, 'em' ) == false
                     && strpos( $string, '%' ) == false
                     && strpos( $string, 'pt' ) == false )
                {
                    return $operatorValue = $string . 'px';
                }
            } break;
            
            case 'autofont':
            {
                $count = strlen( $operatorValue );
                $identifier = $namedParameters['identifier'];
                //eZDebug::writeNotice($count);
                $fontsize =  $this->ini->hasVariable( 'TitleSize', $identifier . '_LengthSize' ) ? $this->ini->variable( 'TitleSize', $identifier . '_LengthSize' ) : array();
                //eZDebug::writeNotice($fontsize);
                $dosize = 0;
                foreach( $fontsize as $lenght => $size )
                {
                    if ( $count > $lenght )
                    {
                        $dosize = $size;
                    }
                }
                //eZDebug::writeNotice($dosize);
                if ( $dosize > 0 )
                {
                    return $operatorValue = 'style="font-size:' . $size . 'px"';
                }
                return $operatorValue = false;
            } break;
            
            case 'entelocale_node':
            {
                $nodes = $this->nodes;
                return $operatorValue = array_pop( $nodes );
            } break;
            
            case 'entelocale_info':
            {
                $infoObject = false;
                $nodes = $this->nodes;
                $reverse = array_reverse( $nodes );
                foreach( $reverse as $node )
                {
                    $attributes = $node->attribute( 'object' )->fetchAttributesByIdentifier( array( 'info' ) );
                    if ( is_array( $attributes ) )
                    {
                        foreach( $attributes as $attribute )
                        {
                            if ( $attribute->hasContent() )
                            {
                                $infoObject = $node;
                                break;
                            }
                        }
                    }
                }
                return $operatorValue = $node;
            } break;
            
            case 'entelocale_background':
            {
                $background = '';
                $nodes = $this->nodes;
                $reverse = array_reverse( $nodes );
                
                foreach( $reverse as $node )
                {
                    $attributes = $node->attribute( 'object' )->fetchAttributesByIdentifier( array( 'background' ) );
                    if ( is_array( $attributes ) )
                    {                        
                        foreach( $attributes as $attribute )
                        {                            
                            if ( $attribute->hasContent() )
                            {                                
                                $image = $attribute->content();
                                //eZDebug::writeNotice($image->attributes(), __METHOD__ );
                                if ( $image->hasAttribute( 'background' ) )
                                {
                                    $backgroundObject = $image->attribute( 'background' );
                                    //eZDebug::writeNotice( $backgroundObject, __METHOD__ );
                                    if ( isset( $backgroundObject['full_path'] ) )
                                    {
                                        $background = ' style="background-image: url(/' . $backgroundObject['full_path'] . ');"';
                                    }
                                }
                            }
                        }
                    }
                }
                return $operatorValue = $background;
            } break;
            
            case 'is_comune':
            {
                $node = $operatorValue;
                $result = false;
                if ( $node instanceof eZContentObjectTreeNode )
                {
                    if ( $node->attribute( 'class_identifier' ) == 'comune' )
                    {
                        $result = $node;
                    }
                }
                return $operatorValue = $result;
            } break;
            
            case 'is_comuni_folder':
            {
                $node = $operatorValue;
                $result = false;
                if ( $node instanceof eZContentObjectTreeNode
                     && OpenPAINI::variable( 'TopMenu', 'CustomMenuComuni', 'enabled' ) == 'enabled' )
                {
                    foreach ( $node->attribute( 'children' ) as $child )
                    {
                        if ( $child->attribute( 'class_identifier' ) == 'comune' )
                        {
                            $result = $node;
                        }
                    }
                }
                return $operatorValue = $result;
            } break;
            
            case 'authorized_apps':
            {
                $operatorValue = $this->getAuthorizedClients( $operatorValue );
            } break;
            
        }
    }
    
    protected function getAuthorizedClients( $user )
    {
        $data = array();
        if ( $user instanceof eZUser )
        {
            try
            {
                require_once 'kernel/private/rest/classes/lazy.php';
                $session = ezcPersistentSessionInstance::get();
                $q = $session->createFindQuery( 'ezpRestAuthorizedClient' );
                $q->where( $q->expr->eq( 'user_id', $q->bindValue( $user->attribute( 'contentobject_id' ) ) ) );
                $results = $session->find( $q, 'ezpRestAuthorizedClient' );
                foreach( $results as $result )
                {
                    if ( $result instanceof ezpRestAuthorizedClient )
                    {                        
                        $clientId = $result->rest_client_id;
                        $q = $session->createFindQuery( 'ezpRestClient' );
                        $q->where( $q->expr->eq( 'id', $q->bindValue( $clientId ) ) );
                        $client = $session->find( $q, 'ezpRestClient' );                        

                        if ( count( $client ) > 0 )
                        {
                            $row = array_shift( $client );
                            $formatted = array();
                            $formatted['name'] = $row->name;
                            $formatted['description'] = $row->description;
                            $endpoint = parse_url( $row->endpoint_uri );
                            $formatted['site'] = $endpoint['host'];
                            $formatted['version'] = $row->version;
                            $data[] = $formatted;
                        }   
                    }
                }
            }
            catch( Exception $e )
            {
                eZDebug::writeError( $e->getMessage(), __METHOD__ );
            }
        }
        return $data;
    }
    
    public function nodes()
    {
        if ( empty( $this->nodes ) )
        {
            if ( $this->tpl->hasVariable('module_result') )
            {
               $moduleResult = $this->tpl->variable('module_result');
            }
            else
            {
                $moduleResult = array();
            }
            $names = array();
            $nodes = array();
            $root = eZContentObjectTreeNode::fetch( eZINI::instance( 'content.ini' )->variable( 'NodeSettings', 'RootNode' ) );
            $path = ( isset( $moduleResult['path'] ) && is_array( $moduleResult['path'] ) ) ? $moduleResult['path'] : array();
            $identifiers =  $this->ini->hasVariable( 'SubSiteIdentifiers', 'Identifiers' ) ? $this->ini->variable( 'SubSiteIdentifiers', 'Identifiers' ) : array();
            foreach ( $path as $key => $item )
            {
                if ( isset( $item['node_id'] ) )
                {
                    $node = eZContentObjectTreeNode::fetch( $item['node_id'] );
                    if ( $node && ( $item['node_id'] != 2 ) && in_array( $node->attribute( 'class_identifier' ), $identifiers ) )
                    {
                        $nodes[] = $node;
                        $names[] = $node->attribute( 'name' );
                    }
                }
            }
            if( empty( $nodes ) )
            {
                $nodes = array( $root );
            }
            $this->nodes = $nodes;            
        }        
        return $this->nodes;
    }
    
}

?>