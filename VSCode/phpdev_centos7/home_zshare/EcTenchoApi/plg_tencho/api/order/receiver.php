<?php
require_once '../../../require.php';
require_once '../plg_EcTenchoApi_Common.php';

/**  Commonから
 *   $request_body API呼び出しの際渡されたBodyデーター
 */

switch($_SERVER['REQUEST_METHOD']){
    case 'GET':
        $objQuery =& SC_Query_Ex::getSingletonInstance();
        $select = "S.shipping_name01||S.shipping_name02 as name, S.shipping_kana01||S.shipping_kana02 as name_furigana, S.shipping_tel01||'-'||S.shipping_tel02||'-'||S.shipping_tel03 as phone, S.shipping_zip01||'-'||S.shipping_zip02 as zipcode, S.shipping_addr01 as address1, S.shipping_addr02 as address2, mP.name as address_state, mP.name||S.shipping_addr01||S.shipping_addr02 as address_full";
        $where = 'O.del_flg = 0
                    AND O.order_id = ?
                    AND O.order_id = S.order_id
                    AND S.shipping_pref = mP.id';
        $tables = "dtb_order O, dtb_shipping S, mtb_pref mP";
        $timeLimit = date('Y-m-d', strtotime('-3 months'));

        //offset&limit
        $offset = empty($_GET['offset']) ? 0 : min($_GET['offset'],8000);
        $limit = empty($_GET['limit']) ? 10 : min($_GET['limit'],500);
        $objQuery->setLimitOffset($limit,$offset);

        /*
        //start_date
        $where .= " AND O.create_date > '";
        if(empty($_GET['start_date'])){
            $where .= $timeLimit."'";
        }
        else{
            $where .= ($_GET['start_date'] > $timeLimit) ? $_GET['start_date'] : $timeLimit;
            $where .= "'";
        }

        //end_date
        if(!empty($_GET['end_date'])){
            $where .= " AND O.create_date < '";
            $where .= ($_GET['end_date'] > $timeLimit) ? $_GET['end_date'] : $timeLimit;
            $where .= "'";
        }
        */
        //order_id
        if(empty($_GET['order_id'])){
            $error->error->message = "'order_id' is empty";
            $error->error->code = 422;
            http_response_code(422);
            echo json_encode($error);
        }
        else{
            $arrReceiver = $objQuery->select($select, $tables, $where, array($_GET['order_id']));
            for($i = 0; $i<count($arrReceiver); $i++){
                $arrReceiver[$i]["shop_no"] = $shop_no;
            }
            $result = (object)array(
                'receivers' => $arrReceiver
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

