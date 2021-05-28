<?php

require_once PLUGIN_UPLOAD_REALDIR . basename(__DIR__) . '/LC_Page_Plugin_EcTenchoApi_Config.php';
$objPage = new LC_Page_Plugin_EcTenchoApi_Config();
register_shutdown_function(array($objPage, 'destroy'));
$objPage->init();
$objPage->process();


?>

