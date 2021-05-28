<?php
require_once '../../../require.php';
require_once '../plg_EcTenchoApi_Common.php';

/**  Commonから
 *   $request_body API呼び出しの際渡されたBodyデーター
 */

switch($_SERVER['REQUEST_METHOD']){
    case 'GET':
        $objQuery =& SC_Query_Ex::getSingletonInstance();
        $select = "Odt.order_detail_id as order_item_code,
                    Pd.product_class_id AS variant_code,
                    Pd.product_code AS custom_product_code,
                    Pd.product_id AS product_no,
                    Pd.price02 AS product_price,
                    Pd.name AS product_name,
                    Pd.class_name01,
                    Pd.category_name01,
                    Pd.class_name02,
                    Pd.category_name02,
                    Odt.quantity,
                    O.status as order_status";
        $where = 'O.del_flg = 0
                    AND O.order_id = ?
                    AND O.order_id = Odt.order_id
                    AND Odt.product_class_id = Pd.product_class_id';
        $tables = "dtb_order O, 
                    dtb_order_detail Odt, 
                    (SELECT 
                        Pc.product_class_id,
                            Pc.product_id,
                            C1.class_name AS class_name01,
                            C1.category_name AS category_name01,
                            C2.class_name AS class_name02,
                            C2.category_name AS category_name02,
                            Pc.product_code,
                            Pc.price02,
                            P.name
                    FROM
                        dtb_products_class Pc
                    INNER JOIN dtb_products P ON Pc.product_id = P.product_id
                    LEFT JOIN (SELECT 
                        Ca.classcategory_id,
                            Ca.name AS category_name,
                            Cl.name AS class_name
                    FROM
                        dtb_classcategory Ca
                    INNER JOIN dtb_class Cl ON Ca.class_id = Cl.class_id) AS C1 ON Pc.classcategory_id1 = C1.classcategory_id
                    LEFT JOIN (SELECT 
                        Ca.classcategory_id,
                            Ca.name AS category_name,
                            Cl.name AS class_name
                    FROM
                        dtb_classcategory Ca
                    INNER JOIN dtb_class Cl ON Ca.class_id = Cl.class_id) AS C2 ON Pc.classcategory_id2 = C2.classcategory_id) AS Pd";
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
            $arrItem = $objQuery->select($select, $tables, $where, array($_GET['order_id']));
            for($i = 0; $i<count($arrItem); $i++){
                $arrItem[$i]["shop_no"] = $shop_no;
            }
            $result = (object)array(
                'orders' => $arrItem
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

