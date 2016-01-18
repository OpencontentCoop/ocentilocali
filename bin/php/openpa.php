<?php

include( 'autoload.php' );
$arguments = OpenPABase::getOpenPAScriptArguments();
$_siteaccess = OpenPABase::getInstances( 'backend' );
$siteaccess = array();
foreach( $_siteaccess as $sa )
{    
    if ( strpos( $sa, 'default_' ) === false )
    {
        $siteaccess[] = $sa;
    }
}


if ( in_array( 'help', $arguments ) )
{
    print "\n\nEsecuzione di script php di openpa su tutte le istanze attive (versione entilocali)\n\n";
    print "\tphp extension/ocentilocali/bin/php/openpa.php <nome_file_script_senza_estensione> <parametri> \n\n";
    print "Esempio:\nphp extension/ocentilocali/bin/php/openpa.php check_class --class=folder \nesegue lo script \"php extension/openpa/bin/php/check_class.php\" con i parametri \"--class=folder\" su tutte le istanze\n\n";
    print "E' possibile usare inoltre i seguenti parametri:\n\n";
    print "\tsleep\t ferma l'esecuzione per 2 secondi dopo l'esecuzione dello script su un'istanza\n";
    print "\tclear\t pulisce lo schermo dopo l'esecuzione dello script su un'istanza\n";
    print "\tbell\t emette un suono dopo l'esecuzione dello script su un'istanza\n\n";
    print "I siteaccess attivi sono:\n\n";
    print_r( $siteaccess );
    eZExecution::cleanExit();
}

$script = array_shift( $arguments );
foreach( $siteaccess as $sa )
{    
    $command = "php extension/ocentilocali/bin/php/{$script}.php -s{$sa} " . implode( ' ', $arguments );
    print "\nEseguo: $command \n";
    system( $command );
    
    if ( in_array( 'sleep', $arguments ) ) sleep(2);
    if ( in_array( 'clear', $arguments ) ) system( 'clear' );
    if ( in_array( 'bell', $arguments ) ) system( 'tput bel' ); 
}

?>
