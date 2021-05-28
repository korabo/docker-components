<?php
require_once '../../../require.php';
require_once '../plg_EcTenchoApi_Common.php';

/**  Commonから
 *   $request_body API呼び出しの際渡されたBodyデーター
 *   $error        エラーフレイム
 */

 //アップデート確認用コメント


switch($_SERVER['REQUEST_METHOD']){
    case 'GET':
        $objQuery =& SC_Query_Ex::getSingletonInstance();
        $cols = "O.order_id, 
                O.order_name01||O.order_name02 as buyer_name, 
                O.order_email as buyer_email, 
                O.order_tel01||'-'||O.order_tel02||'-'||O.order_tel03 as buyer_phone, 
                O.customer_id, O.payment_id, 
                O.payment_method as payment_name,
                O.create_date as order_date, 
                O.total as order_price_amount, 
                O.payment_total,
                O.discount,
                O.tax,
                O.charge,
                O.use_point,
                O.deliv_name,
                O.deliv_service_name,
                O.deliv_fee as shipping_fee";
        $where = 'O.del_flg = 0';
        $tables = "(SELECT 
                        dtb_order.*,
                        dtb_deliv.name as deliv_name,
                        dtb_deliv.service_name as deliv_service_name
                    FROM 
                        dtb_order 
                    LEFT JOIN dtb_deliv ON dtb_order.deliv_id = dtb_deliv.deliv_id
                        ) AS O";
        $timeLimit = date('Y-m-d', strtotime('-3 months'));
        $embed_list = explode(',', $_GET['embed']);

        //offset&limit
        $offset = empty($_GET['offset']) ? 0 : min($_GET['offset'],8000);
        $limit = empty($_GET['limit']) ? 10 : min($_GET['limit'],500);
        $objQuery->setLimitOffset($limit,$offset);

        //start_date
        if(empty($_GET['start_date'])){
        }
        else{
            $start_date_param = $_GET['start_date'];
            if(preg_match("/^[0-9]{4}-[0-9]{2}-[0-9]{2}$/", $start_date_param)){
                $where .= " AND O.create_date > '";
                //$where .= ($start_date_param > $timeLimit) ? $start_date_param : $timeLimit;
                $where .= $start_date_param;
                $where .= " 00:00:00'";
            }
            else{
            }
        }

        //end_date
        if(!empty($_GET['end_date'])){
            $end_date_param = $_GET['end_date'];
            if(preg_match("/^[0-9]{4}-[0-9]{2}-[0-9]{2}$/", $end_date_param)){
                $where .= " AND O.create_date < '";
                //$where .= ($end_date_param > $timeLimit) ? $end_date_param : $timeLimit;
                $where .= $end_date_param;
                $where .= " 23:59:59'";
            }
           
        }

        //status
        if(!empty($_GET['status'])){
            $status_param = $_GET['status'];
            $status_params = explode(",",$status_param);
            if(count($status_params) != 0){
                
                $newWhere = " AND (";
                $insertFlag = false;
                foreach($status_params as $param){
                    if(is_numeric($param) && (int)$param > 0){
                        if($insertFlag){
                            $newWhere .= " OR";
                        }
                        $newWhere .= " O.status = ";
                        $newWhere .= $param;
                        $insertFlag = true;
                    }
                }
                $newWhere .= ")";
                if($insertFlag){
                    $where .= $newWhere;
                }
                
            }
            
        }

        //embed
        if(!empty($embed_list)){
            if(in_array("items", $embed_list)){
                if(strpos($cols, "Odt.order_detail_id as order_item_code") === false){
                    $cols .= ", Odt.order_detail_id as order_item_code";
                }
                if(strpos($cols, "Pd.product_class_id as variant_code") === false){
                    $cols .= ", Pd.product_class_id as variant_code";
                }
                if(strpos($cols, "Pd.product_code as custom_product_code") === false){
                    $cols .= ", Pd.product_code as custom_product_code";
                }
                if(strpos($cols, "Pd.product_id as product_no") === false){
                    $cols .= ", Pd.product_id as product_no";
                }
                if(strpos($cols, "Pd.price02 as product_price") === false){
                    $cols .= ", Pd.price02 as product_price";
                }
                if(strpos($cols, "Pd.name as product_name") === false){
                    $cols .= ", Pd.name as product_name";
                }
                if(strpos($cols, "Pd.class_name01") === false){
                    $cols .= ", Pd.class_name01";
                }
                if(strpos($cols, "Pd.category_name01") === false){
                    $cols .= ", Pd.category_name01";
                }
                if(strpos($cols, "Pd.class_name02") === false){
                    $cols .= ", Pd.class_name02";
                }
                if(strpos($cols, "Pd.category_name02") === false){
                    $cols .= ", Pd.category_name02";
                }
                if(strpos($cols, "Odt.quantity") === false){
                    $cols .= ", Odt.quantity";
                }
                if(strpos($cols, "O.status as order_status") === false){
                    $cols .= ", O.status as order_status";
                }
                if(strpos($tables, "dtb_order_detail Odt") === false){
                    $tables .= ", dtb_order_detail Odt";
                }
                if(strpos($tables, "(SELECT Pc.product_class_id, 
                                            Pc.product_id, 
                                            C1.class_name as class_name01, 
                                            C1.category_name as category_name01,
                                            C2.class_name as class_name02, 
                                            C2.category_name as category_name02,
                                            Pc.product_code,
                                            Pc.price02,
                                            P.name
                                    FROM dtb_products_class Pc INNER JOIN dtb_products P 
                                                                    ON Pc.product_id = P.product_id
                                                                LEFT JOIN (SELECT Ca.classcategory_id, Ca.name as category_name, Cl.name as class_name FROM dtb_classcategory Ca INNER JOIN dtb_class Cl ON Ca.class_id = Cl.class_id) AS C1
                                                                    ON Pc.classcategory_id1 = C1.classcategory_id
                                                                LEFT JOIN (SELECT Ca.classcategory_id, Ca.name as category_name, Cl.name as class_name FROM dtb_classcategory Ca INNER JOIN dtb_class Cl ON Ca.class_id = Cl.class_id) AS C2
                                                                    ON Pc.classcategory_id2 = C2.classcategory_id) as Pd") === false){
                    $tables .= ", (SELECT Pc.product_class_id, 
                                            Pc.product_id, 
                                            C1.class_name as class_name01, 
                                            C1.category_name as category_name01,
                                            C2.class_name as class_name02, 
                                            C2.category_name as category_name02,
                                            Pc.product_code,
                                            Pc.price02,
                                            P.name
                                    FROM dtb_products_class Pc INNER JOIN dtb_products P 
                                                                    ON Pc.product_id = P.product_id
                                                                LEFT JOIN (SELECT Ca.classcategory_id, Ca.name as category_name, Cl.name as class_name FROM dtb_classcategory Ca INNER JOIN dtb_class Cl ON Ca.class_id = Cl.class_id) AS C1
                                                                    ON Pc.classcategory_id1 = C1.classcategory_id
                                                                LEFT JOIN (SELECT Ca.classcategory_id, Ca.name as category_name, Cl.name as class_name FROM dtb_classcategory Ca INNER JOIN dtb_class Cl ON Ca.class_id = Cl.class_id) AS C2
                                                                    ON Pc.classcategory_id2 = C2.classcategory_id) as Pd";
                }
                if(strpos($where, "O.order_id = Odt.order_id") === false){
                    $where .= " AND O.order_id = Odt.order_id";
                }
                if(strpos($where, "Odt.product_id = Pd.product_id") === false){
                    $where .= " AND Odt.product_class_id = Pd.product_class_id";
                }
            }
            if(in_array("buyer", $embed_list)){
                if(strpos($cols, "O.order_kana01||O.order_kana02 as buyer_names_furigana") === false){
                    $cols .= ", O.order_kana01||O.order_kana02 as buyer_names_furigana";
                }
            }
            if(in_array("receiver", $embed_list)){
                if(strpos($cols, "S.shipping_name01||S.shipping_name02 as r_name") === false){
                    $cols .= ", S.shipping_name01||S.shipping_name02 as r_name";
                }
                if(strpos($cols, "S.shipping_kana01||S.shipping_kana02 as r_name_furigana") === false){
                    $cols .= ", S.shipping_kana01||S.shipping_kana02 as r_name_furigana";
                }
                if(strpos($cols, "S.shipping_tel01||'-'||S.shipping_tel02||'-'||S.shipping_tel03 as r_phone") === false){
                    $cols .= ", S.shipping_tel01||'-'||S.shipping_tel02||'-'||S.shipping_tel03 as r_phone";
                }
                if(strpos($cols, "S.shipping_zip01||'-'||S.shipping_zip02 as r_zipcode") === false){
                    $cols .= ", S.shipping_zip01||'-'||S.shipping_zip02 as r_zipcode";
                }
                if(strpos($cols, "S.shipping_addr01 as r_address1") === false){
                    $cols .= ", S.shipping_addr01 as r_address1";
                }
                if(strpos($cols, "S.shipping_addr02 as r_address2") === false){
                    $cols .= ", S.shipping_addr02 as r_address2";
                }
                if(strpos($cols, "mP.name as r_address_state") === false){
                    $cols .= ", mP.name as r_address_state";
                }
                if(strpos($cols, "mP.name||S.shipping_addr01||S.shipping_addr02 as r_address_full") === false){
                    $cols .= ", mP.name||S.shipping_addr01||S.shipping_addr02 as r_address_full";
                }
                if(strpos($tables, "dtb_shipping S") === false){
                    $tables .= ", dtb_shipping S";
                }
                if(strpos($tables, "mtb_pref mP") === false){
                    $tables .= ", mtb_pref mP";
                }
                if(strpos($where, "O.order_id = S.order_id") === false){
                    $where .= " AND O.order_id = S.order_id";
                }
                if(strpos($where, "S.shipping_pref = mP.id") === false){
                    $where .= " AND S.shipping_pref = mP.id";
                }
            }

        }

        

        //order_id
        if(empty($_GET['order_id'])){
            $arrOrder = $objQuery->select($cols, $tables, $where, array());
        }
        else{
            $searchOrderId = explode(',',$_GET['order_id']);
            $whereOrderIdArrStr = '('.implode(',', array_fill( 0, count($searchOrderId), "?" )).')';
            $where .= ' AND O.order_id IN '.$whereOrderIdArrStr;
            $arrOrder = $objQuery->select($cols, $tables, $where, $searchOrderId);
            
        }
        $found = array();
        $willRemove = array();
        for($i = 0; $i<count($arrOrder); $i++){
            $arrOrder[$i]["shop_no"] = $shop_no;
            if(in_array("items", $embed_list)){
                if(!array_key_exists($arrOrder[$i]["order_id"], $found)){
                    $found[$arrOrder[$i]["order_id"]] = $i;
                    $arrOrder[$i]["items"] = array(
                        array(
                            "order_item_code" => $arrOrder[$i]["order_item_code"],
                            "variant_code" => $arrOrder[$i]["variant_code"],
                            "custom_product_code" => $arrOrder[$i]["custom_product_code"],
                            "product_no" => $arrOrder[$i]["product_no"],
                            "product_price" => $arrOrder[$i]["product_price"],
                            "product_name" => $arrOrder[$i]["product_name"],
                            "quantity" => $arrOrder[$i]["quantity"],
                            "order_status" => $arrOrder[$i]["order_status"],
                            "class_name01" => $arrOrder[$i]["class_name01"],
                            "category_name01" => $arrOrder[$i]["category_name01"],
                            "class_name02" => $arrOrder[$i]["class_name02"],
                            "category_name02" => $arrOrder[$i]["category_name02"]

                        )
                    );
                    unset($arrOrder[$i]["order_item_code"]);
                    unset($arrOrder[$i]["variant_code"]);
                    unset($arrOrder[$i]["custom_product_code"]);
                    unset($arrOrder[$i]["product_no"]);
                    unset($arrOrder[$i]["product_price"]);
                    unset($arrOrder[$i]["product_name"]);
                    unset($arrOrder[$i]["quantity"]);
                    unset($arrOrder[$i]["order_status"]);
                    unset($arrOrder[$i]["class_name01"]);
                    unset($arrOrder[$i]["category_name01"]);
                    unset($arrOrder[$i]["class_name02"]);
                    unset($arrOrder[$i]["category_name02"]);
                }
                else{
                    array_push($arrOrder[$found[$arrOrder[$i]["order_id"]]]["items"], 
                                array(
                                    "order_item_code" => $arrOrder[$i]["order_item_code"],
                                    "variant_code" => $arrOrder[$i]["variant_code"],
                                    "custom_product_code" => $arrOrder[$i]["custom_product_code"],
                                    "product_no" => $arrOrder[$i]["product_no"],
                                    "product_price" => $arrOrder[$i]["product_price"],
                                    "product_name" => $arrOrder[$i]["product_name"],
                                    "quantity" => $arrOrder[$i]["quantity"],
                                    "order_status" => $arrOrder[$i]["order_status"],
                                    "class_name01" => $arrOrder[$i]["class_name01"],
                                    "category_name01" => $arrOrder[$i]["category_name01"],
                                    "class_name02" => $arrOrder[$i]["class_name02"],
                                    "category_name02" => $arrOrder[$i]["category_name02"]
                                )
                            );
                    $willRemove[] = $i;
                }
            }
            if(in_array("receiver", $embed_list)){
                $arrOrder[$i]["receiver"] = array(
                    "name" => $arrOrder[$i]["r_name"],
                    "name_furigana" => $arrOrder[$i]["r_name_furigana"],
                    "phone" => $arrOrder[$i]["r_phone"],
                    "zipcode" => $arrOrder[$i]["r_zipcode"],
                    "address1" => $arrOrder[$i]["r_address1"],
                    "address2" => $arrOrder[$i]["r_address2"],
                    "address_state" => $arrOrder[$i]["r_address_state"],
                    "address_full" => $arrOrder[$i]["r_address_full"]
                );
                unset($arrOrder[$i]["r_name"]);
                unset($arrOrder[$i]["r_name_furigana"]);
                unset($arrOrder[$i]["r_phone"]);
                unset($arrOrder[$i]["r_zipcode"]);
                unset($arrOrder[$i]["r_address1"]);
                unset($arrOrder[$i]["r_address2"]);
                unset($arrOrder[$i]["r_address_state"]);
                unset($arrOrder[$i]["r_address_full"]);
                
            }
        }
        for($i = count($willRemove) - 1; $i >= 0; $i--){
            unset($arrOrder[$willRemove[$i]]);
        }
        $result = (object)array(
            'orders' => array_values($arrOrder)
        );
        
        echo json_encode($result);
        break;
    case 'POST':
        echo 'POST';
        break;
    case 'PUT':
        /* 必須パラメータ検査 in request body */
        if(empty($request_body)){
            $error->error->message = 'HTTP Request body is nessesary';
            $error->error->code = 422;
            http_response_code(422);
            echo json_encode($error);
            break;
        }
        if(empty($request_body->requests)){
            $error->error->message = "'requests' is empty";
            $error->error->code = 422;
            http_response_code(422);
            echo json_encode($error);
            break;
        }
        $objQuery =& SC_Query_Ex::getSingletonInstance();
        $table = "dtb_order";
        $result = array(
            'orders' => array()
        );
        foreach($request_body->requests as $order){
            if(!empty($order->order_id) && !empty($order->process_status)){
                $status = getStatus($order->process_status);
                if($status != null){
                    $arrVal = array(
                        'status' => $status
                    );
                    $where = "order_id = ?";
                    $arrWhereVal = array($order->order_id);
                    $objQuery =& SC_Query_Ex::getSingletonInstance();
                    $update_result = $objQuery->update($table, $arrVal, $where, $arrWhereVal);
                    if($update_result){
                        $sel = $objQuery->getRow('order_id, status as process_status', $table, $where, $arrWhereVal);
                        $sel["shop_no"] = $shop_no;
                        $result['orders'][] = $sel;
                    }
                }
            }
        }
        echo json_encode($result);
        /*
        $where = "product_class_id = ? 
                    AND product_id = ?";
        $arrWhereVal = array($_GET['product_class_id'],$_GET['product_id']);
        $objQuery =& SC_Query_Ex::getSingletonInstance();
        $update_result = $objQuery->update($table, $arrVal, $where, $arrWhereVal);
        */
        break;
    case 'DELETE';
        break;
    default:
        break;
}

function getStatus($process_status){
    $status_list = array(
        'neworder' => 1,
        'notpaid' => 2,
        'cancel' => 3,
        'prepareproduct' => 4,
        'send' => 5,
        'paid' => 6,
        'processpayment' => 7
    );
    if(in_array($process_status, $status_list)){
        return $process_status;
    }
    if(key_exists($process_status, $status_list)){
        return $status_list[$process_status];
    }
    else{
        return null;
    }
}



?>

