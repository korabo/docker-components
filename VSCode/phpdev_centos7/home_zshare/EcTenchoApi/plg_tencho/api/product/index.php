<?php
require_once '../../../require.php';
require_once '../plg_EcTenchoApi_Common.php';

/**  Commonから
 *   $request_body API呼び出しの際渡されたBodyデーター
 */

switch($_SERVER['REQUEST_METHOD']){
    case 'GET':
        
        break;
    case 'POST':
        
        break;
    case 'PUT':
        /* 必須パラメータ検査 in request body */
        if(empty($request_body)){
            $error->error->message = "HTTP Request body is nessesary";
            $error->error->code = 422;
            http_response_code(422);
            echo json_encode($error);
            break;
        }
        if(empty($request_body->request)){
            $error->error->message = "'request' is must be contained in request body";
            $error->error->code = 422;
            http_response_code(422);
            echo json_encode($error);
            break;
        }
        else{
            if(count($request_body->request) <= 0){
                $error->error->message = "'request' is empty";
                $error->error->code = 422;
                http_response_code(422);
                echo json_encode($error);
                break;
            }

            $table = "dtb_products_class";
            $where = "product_class_id = ? 
                        AND product_id = ?";
            $result = (object)array(products => array());
            foreach($request_body->request as $req){
                $arrVal = array();
                if(empty($req->product_class_id) || empty($req->product_id)){
                    break;
                }
                if(!empty($req->quantity)){
                    $arrVal['stock'] = $req->quantity;
                }
                if(!empty($req->price)){
                    $arrVal['price02'] = $req->price;
                }
                if(empty($arrVal)){
                    continue;
                }
                $arrWhereVal = array($req->product_class_id, $req->product_id);
                $objQuery =& SC_Query_Ex::getSingletonInstance();
                $update_result = $objQuery->update($table, $arrVal, $where, $arrWhereVal);
                if($update_result == true){
                    $updateResultRecode = $objQuery->select('*', $table, $where, $arrWhereVal);
                    
                    $result->products[] = $updateResultRecode[0];
                }
            }
            $result->shop_no = $shop_no;
            echo json_encode($result);

        }
        break;
    case 'DELETE';
        break;
    default:
        break;
}


?>