<?php
$error = (object)array(
    'error' => (object)array(
        'code' => 500,
        'message' => 'Internal Server Error',
        'more_info' => (object)array()
    )
);
http_response_code(500);
echo json_encode($error);

?>