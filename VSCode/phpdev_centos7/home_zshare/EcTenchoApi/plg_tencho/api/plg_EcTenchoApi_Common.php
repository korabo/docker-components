<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Authorization, Content-Type");
header("Content-Type: application/json");

include_once '../../require.php';

date_default_timezone_set('Asia/Tokyo');

const PLUGIN_CODE = 'EcTenchoApi';

//エラー
$error = (object)array(
    'error' => (object)array(
        'code' => 0,
        'message' => '',
        'more_info' => (object)array()
    )
    );


/*
    認証キーを獲得
*/
if(array_key_exists('HTTP_AUTHORIZATION',$_SERVER)){
    $authHeader = trim($_SERVER['HTTP_AUTHORIZATION']);
}
else if(array_key_exists('Authorization',$_SERVER)){
    $authHeader = trim($_SERVER['Authorization']);
}
else{
    $authHeader = null;
}
if(strpos($authHeader, 'Basic ') !== 0){
    $error->error->message = "Invalid Authorization";
    $error->error->code = 401;
    http_response_code(401);
    echo json_encode($error);
    exit;
}
$token = explode(' ', $authHeader)[1];
$token = base64_decode($token);
$objQuery =& SC_Query_Ex::getSingletonInstance();
$where = 'plugin_code = ?';
$pluginData = $objQuery->getRow('*', 'dtb_plugin', $where, array(PLUGIN_CODE));
if(empty($pluginData['free_field1']) || empty($pluginData['free_field2'])){
    $error->error->message = "Authorization Not Registered";
    $error->error->code = 401;
    http_response_code(401);
    echo json_encode($error);
    exit;
}
if($token !== $pluginData['free_field1'].':'.$pluginData['free_field2']){
    $error->error->message = "Incorrect Authorization";
    $error->error->code = 401;
    http_response_code(401);
    echo json_encode($error);
    exit();
}

$request_body = json_decode(@file_get_contents('php://input'));
$shop_no = $pluginData['free_field3'];







?>

