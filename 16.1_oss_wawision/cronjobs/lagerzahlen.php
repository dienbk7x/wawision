<?php
/*
**** COPYRIGHT & LICENSE NOTICE *** DO NOT REMOVE ****
* 
* WaWision (c) embedded projects GmbH, Holzbachstrasse 4, D-86154 Augsburg, * Germany 2015 
*
* This file is licensed under the Embedded Projects General Public License *Version 3.1. 
*
* You should have received a copy of this license from your vendor and/or *along with this file; If not, please visit www.wawision.de/Lizenzhinweis 
* to obtain the text of the corresponding license version.  
*
**** END OF COPYRIGHT & LICENSE NOTICE *** DO NOT REMOVE ****
*/
?>
<?php
/*
include(dirname(__FILE__)."/../conf/main.conf.php");
include(dirname(__FILE__)."/../phpwf/plugins/class.mysql.php");
include(dirname(__FILE__)."/../www/lib/imap.inc.php");
include(dirname(__FILE__)."/../www/lib/class.erpapi.php");
include(dirname(__FILE__)."/../www/lib/class.remote.php");
include(dirname(__FILE__)."/../www/lib/class.httpclient.php");
include(dirname(__FILE__)."/../www/lib/class.aes.php");
include(dirname(__FILE__)."/../www/plugins/phpmailer/class.phpmailer.php");
include(dirname(__FILE__)."/../www/plugins/phpmailer/class.smtp.php");



class app_t {
  var $DB;
  var $erp;
  var $user;
  var $remote;
}
*/
//ENDE

$app = new app_t();


$conf = new Config();
$app->DB = new DB($conf->WFdbhost,$conf->WFdbname,$conf->WFdbuser,$conf->WFdbpass);
$erp = new erpAPI($app);
$app->erp = $erp;
$remote = new Remote($app);
$app->remote = $remote;

$app->erp->LogFile("Starte Synchronisation");

//$app->DB->Update("UPDATE artikel SET cache_lagerplatzinhaltmenge='999'");

$firmendatenid = $app->DB->Select("SELECT MAX(id) FROM firmendaten LIMIT 1");

$benutzername = $app->DB->Select("SELECT benutzername FROM firmendaten WHERE id='".$firmendatenid."' LIMIT 1");
$passwort = $app->DB->Select("SELECT passwort FROM firmendaten WHERE id='".$firmendatenid."' LIMIT 1");
$host = $app->DB->Select("SELECT host FROM firmendaten WHERE id='".$firmendatenid."' LIMIT 1");
$port = $app->DB->Select("SELECT port FROM firmendaten WHERE id='".$firmendatenid."' LIMIT 1");
$mailssl = $app->DB->Select("SELECT mailssl FROM firmendaten WHERE id='".$firmendatenid."' LIMIT 1");

$app->mail = new PHPMailer($app);
//$app->mail->PluginDir="plugins/phpmailer/";
$app->mail->IsSMTP();
$app->mail->SMTPAuth   = true;                  // enable SMTP authentication
if($mailssl)
$app->mail->SMTPSecure = "ssl";                 // sets the prefix to the servier
$app->mail->Host       = $host;
$app->mail->Port       = $port;                   // set the SMTP port for the GMAIL server

$app->mail->Username   = $benutzername;
$app->mail->Password   = $passwort;

//$app->DB->Update("UPDATE artikel SET cache_lagerplatzinhaltmenge=0 WHERE (shop > 0 OR shop2 > 0 OR shop3 > 0)");

$lagerartikel = $app->DB->SelectArr("SELECT id,restmenge,name_de,lieferzeit,cache_lagerplatzinhaltmenge,juststueckliste FROM artikel WHERE (lagerartikel='1' OR (stueckliste='1' AND juststueckliste='1')) AND autolagerlampe='1' AND (shop > 0 OR shop2 > 0 OR shop3 > 0)");

//echo "count ".count($lagerartikel);
$app->erp->LogFile("Artikel Gesamt fuer Synchronisation: ".count($lagerartikel));

for($ij=0;$ij<count($lagerartikel);$ij++)
{
	//$app->erp->LogFile("artikel lagersync ".$lagerartikel[$ij]['id']);
  $message .= $app->erp->LagerSync($lagerartikel[$ij]['id'],true);
}

if($message !="")
{
  $erp->MailSend($erp->GetFirmaMail(),$erp->GetFirmaName(),$erp->GetFirmaBCC1(),"Lagerverwaltung","Systemmeldung: Auto Update Lagerlampen",$message);
}

$app->erp->LogFile("Ende Synchronisation");

?>
