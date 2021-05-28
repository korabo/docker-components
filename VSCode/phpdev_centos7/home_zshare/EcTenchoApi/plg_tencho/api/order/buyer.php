<?php
require_once '../../../require.php';
require_once '../plg_EcTenchoApi_Common.php';

/**  Commonから
 *   $request_body API呼び出しの際渡されたBodyデーター
 */

switch($_SERVER['REQUEST_METHOD']){
    case 'GET':
        $objQuery =& SC_Query_Ex::getSingletonInstance();
        $select = "O.customer_id as member_id, 
                    O.order_name01||O.order_name02 as name, 
                    O.order_kana01||O.order_kana02 as names_furigana, 
                    O.order_email as email, 
                    O.order_tel01||'-'||O.order_tel02||'-'||O.order_tel03 as phone";
        $where = 'O.del_flg = 0 AND O.order_id = ?';
        $tables = "dtb_order O";
        $timeLimit = date('Y-m-d', strtotime('-3 months'));

        //order_id
        if(empty($_GET['order_id'])){
            $error->error->message = "'order_id' is empty";
            $error->error->code = 422;
            http_response_code(422);
            echo json_encode($error);
        }
        else{
            $buyerData = $objQuery->getRow($select, $tables, $where, array($_GET['order_id']));
            $buyerData["shop_no"] = $shop_no;
            $result = (object)array(
                'buyer' => $buyerData
            );
            echo json_encode($result);
        }
        break;
    case 'POST':
        
        break;
    case 'PUT':
        
        break;
    case 'DELETE';
        break;
    default:
        break;
}




?>

