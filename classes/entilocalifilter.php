<?php

class EntilocaliFilter
{
    public static function input( $uri )
    {
        $currentSiteaccess = eZSiteAccess::current();
        $http = eZHTTPTool::instance();
        
        if ( $currentSiteaccess && $currentSiteaccess['name'] == 'default_ita' )
        {
            if ( $uri instanceof eZURI )
            {
                if ( $uri->attribute( 'uri' ) == 'user/register' )
                {
                    $referer = eZURI::decodeURL( $_SERVER['HTTP_REFERER'] );
                    $refererUrl = parse_url( $referer );
                    
                    if ( isset( $refererUrl['query'] )
                         && isset( $refererUrl['host'] )
                         && $refererUrl['host'] == eZINI::instance()->variable( 'SiteSettings', 'SiteURL' )
                         && $refererUrl['path'] == '/oauth/authorize' )
                    {                        
                        $path = $refererUrl['path'] . '/?';
                        $query = $refererUrl['query'];                        
                        parse_str( $query );                        
                        if ( isset( $redirect_uri )
                             && isset( $client_id )
                             && isset( $response_type ) )
                        {                            
                            self::setSessionVariable( $path . urlencode( $query ) );
                        }                        
                    }                    
                }
            }
        }
    }
    
    protected static function setSessionVariable( $var = false )
    {
        $http = eZHTTPTool::instance();
        if ( $http->hasSessionVariable( 'EntiLocaliOauthRequest' ) )
        {
            $http->removeSessionVariable( 'EntiLocaliOauthRequest' );
        }
        if ( $var )
        {
            $http->setSessionVariable( 'EntiLocaliOauthRequest', $var );   
        }        
    }
}