<?php
/*
* EC店長連携可能かですとするためのプラグインメインクラス
*/
class EcTenchoApi extends SC_Plugin_Base {

    const SQL_NAME = "EC店長商品登録用CSV";
    const SQL_NAME_OP = "EC店長商品登録用CSV(オプション)";

	/**
     * コンストラクタ
     *
     */
	public function __construct(array $arrSelfInfo) {
		parent::__construct($arrSelfInfo);
	}

	/**
     * インストール
     * installはプラグインのインストール時に実行されます.
     * 引数にはdtb_pluginのプラグイン情報が渡されます.
     *
     * @param array $arrPlugin plugin_infoを元にDBに登録されたプラグイン情報(dtb_plugin)
     * @return void
     */
	public static function install($arrPlugin, $objPluginInstaller = null) {
          $hostname=$_SERVER["HTTP_HOST"]; 
          $time = strtotime($arrPlugin['create_date']);
          //var_dump($time);
          
          $arrData = array(
               'free_field1' => "",
               'free_field2' => makeRandString(32),
               'free_field3' => 1
          );
          $objQuery =& SC_Query_Ex::getSingletonInstance();
          $result = $objQuery->update("dtb_plugin",$arrData,"plugin_id = ?",array($arrPlugin['plugin_id']));
          
          if(file_exists(PLUGIN_UPLOAD_REALDIR."logo.png")){
            copy(PLUGIN_UPLOAD_REALDIR."logo.png", PLUGIN_HTML_REALDIR."EcTenchoApi/logo.png");
        }
	}

	/**
     * アンインストール
     * uninstallはアンインストール時に実行されます.
     * 引数にはdtb_pluginのプラグイン情報が渡されます.
     *
     * @param array $arrPlugin プラグイン情報の連想配列(dtb_plugin)
     * @return void
     */
	public static function uninstall($arrPlugin, $objPluginInstaller = null) {
        if(file_exists(HTML_REALDIR."plg_tencho")){
            recurse_delete_dir(HTML_REALDIR."plg_tencho");
        }
        $objQuery = new SC_Query();
		$dtb_csv_sql = 'dtb_csv_sql';
		$exist = $objQuery->exists($dtb_csv_sql, "sql_name = '".self::SQL_NAME."'");
		if ($exist){
			$res  = $objQuery->delete($dtb_csv_sql, "sql_name = '".self::SQL_NAME."'");
        }
        $exist = $objQuery->exists($dtb_csv_sql, "sql_name = '".self::SQL_NAME_OP."'");
		if ($exist){
			$res  = $objQuery->delete($dtb_csv_sql, "sql_name = '".self::SQL_NAME_OP."'");
		}
	}

	/**
     * 稼働
     * enableはプラグインを有効にした際に実行されます.
     * 引数にはdtb_pluginのプラグイン情報が渡されます.
     *
     * @param array $arrPlugin プラグイン情報の連想配列(dtb_plugin)
     * @return void
     */
    public static function enable($arrPlugin, $objPluginInstaller = null) {
        if(file_exists(HTML_REALDIR."plg_tencho")){
            recurse_delete_dir(HTML_REALDIR."plg_tencho");
        }
        recurse_copy_dir(PLUGIN_UPLOAD_REALDIR."EcTenchoApi/plg_tencho", HTML_REALDIR."plg_tencho");

        $objQuery = new SC_Query();

        $maxId = $objQuery->getOne("SELECT MAX(sql_id) FROM dtb_csv_sql");
        
		$sqlval['sql_id']= ($maxId == null) ? 1 : (int)$maxId + 1;
		$sqlval['sql_name']=self::SQL_NAME;
		$sqlval['csv_sql']="P_dist.product_code AS 顧客社商品コード,
                            P_dist.product_id AS 商品番号,
                            P_dist.product_class_id AS 品目コード,
                            P_dist.name AS 商品名,
                            IF(P_dist.type IS NULL, 1, 2) AS 在庫タイプ,
                            P_dist.stock AS 在庫数,
                            (SELECT 
                                    dtb_class.name AS class_name
                                FROM
                                    dtb_classcategory
                                        INNER JOIN
                                    dtb_class ON dtb_classcategory.class_id = dtb_class.class_id
                                WHERE
                                    dtb_classcategory.classcategory_id = (SELECT 
                                            Ckr.classcategory_id1
                                        FROM
                                            dtb_products_class Ckr
                                        WHERE
                                            Ckr.product_id = P_dist.product_id
                                                AND Ckr.del_flg = 0
                                                AND (Ckr.classcategory_id1 > 0)
                                        LIMIT 1)) AS 項目選択肢別在庫用横軸項目名,
                            (SELECT 
                                    dtb_class.name AS class_name
                                FROM
                                    dtb_classcategory
                                        INNER JOIN
                                    dtb_class ON dtb_classcategory.class_id = dtb_class.class_id
                                WHERE
                                    dtb_classcategory.classcategory_id = (SELECT 
                                            Ckr.classcategory_id2
                                        FROM
                                            dtb_products_class Ckr
                                        WHERE
                                            Ckr.product_id = P_dist.product_id
                                                AND Ckr.del_flg = 0
                                                AND (Ckr.classcategory_id2 > 0)
                                        LIMIT 1)) AS 項目選択肢別在庫用縦軸項目名
                        FROM
                            (SELECT 
                                dtb_products_class.product_code,
                                    dtb_products_class.product_id,
                                    dtb_products_class.product_class_id,
                                    dtb_products.name,
                                    (SELECT 
                                            Ckr.classcategory_id1
                                        FROM
                                            dtb_products_class Ckr
                                        WHERE
                                            Ckr.product_id = dtb_products.product_id
                                                AND Ckr.del_flg = 0
                                                AND (Ckr.classcategory_id1 > 0
                                                OR Ckr.classcategory_id2 > 0)
                                        LIMIT 1) AS type,
                                        dtb_products_class.stock
                            FROM
                                dtb_products_class
                            JOIN dtb_products ON dtb_products.product_id = dtb_products_class.product_id
                            WHERE
                                dtb_products.del_flg = 0
                                    AND dtb_products_class.product_code IS NOT NULL
                                    AND dtb_products_class.classcategory_id1 = 0
                                    AND dtb_products_class.classcategory_id2 = 0) AS P_dist";
		$sqlval['create_date']="CURRENT_TIMESTAMP";
		$sqlval['update_date']="CURRENT_TIMESTAMP";
        $ret = $objQuery->insert("dtb_csv_sql", $sqlval);
        
        $sqlval['sql_id']= ($maxId == null) ? 2 : (int)$maxId + 2;
		$sqlval['sql_name']=self::SQL_NAME_OP;
		$sqlval['csv_sql']="P_cdr.parent_product_code AS 顧客社商品コード,
                            P_cdr.product_code AS 個別商品コード,
                            P_cdr.product_id AS 商品番号,
                            P_cdr.product_class_id AS 個別品目コード,
                            (SELECT 
                                    name
                                FROM
                                    dtb_classcategory
                                WHERE
                                    dtb_classcategory.classcategory_id = P_cdr.classcategory_id1) AS 項目選択肢別在庫用横軸選択肢,
                            NULL AS 項目選択肢別在庫用横軸選択肢子番号,
                            (SELECT 
                                    name
                                FROM
                                    dtb_classcategory
                                WHERE
                                    dtb_classcategory.classcategory_id = P_cdr.classcategory_id2) AS 項目選択肢別在庫用縦軸選択肢,
                            NULL AS 項目選択肢別在庫用縦軸選択肢子番号,
                            P_cdr.stock AS 項目選択肢別在庫用在庫数
                        FROM
                            (SELECT 
                                (SELECT 
                                            Prts.product_code
                                        FROM
                                            dtb_products_class Prts
                                        WHERE
                                            Prts.product_id = dtb_products.product_id
                                                AND Prts.classcategory_id1 = 0
                                                AND Prts.classcategory_id2 = 0
                                        LIMIT 1) AS parent_product_code,
                                    dtb_products_class.product_code,
                                    dtb_products_class.product_id,
                                    dtb_products_class.product_class_id,
                                    dtb_products_class.classcategory_id1,
                                    dtb_products_class.classcategory_id2,
                                    dtb_products_class.stock
                            FROM
                                dtb_products_class
                            JOIN dtb_products ON dtb_products.product_id = dtb_products_class.product_id
                            WHERE
                                dtb_products.del_flg = 0
                                    AND dtb_products_class.del_flg = 0
                                    AND dtb_products_class.product_code IS NOT NULL
                                    AND NOT (dtb_products_class.classcategory_id1 = 0
                                    AND dtb_products_class.classcategory_id2 = 0)
                                    AND (SELECT 
                                        Prts.product_code
                                    FROM
                                        dtb_products_class Prts
                                    WHERE
                                        Prts.product_id = dtb_products.product_id
                                            AND Prts.classcategory_id1 = 0
                                            AND Prts.classcategory_id2 = 0
                                    LIMIT 1) IS NOT NULL) AS P_cdr";
		$sqlval['create_date']="CURRENT_TIMESTAMP";
		$sqlval['update_date']="CURRENT_TIMESTAMP";
		$ret = $objQuery->insert("dtb_csv_sql", $sqlval);
	}

	/**
     * 停止
     * disableはプラグインを無効にした際に実行されます.
     * 引数にはdtb_pluginのプラグイン情報が渡されます.
     *
     * @param array $arrPlugin プラグイン情報の連想配列(dtb_plugin)
     * @return void
     */
	public static function disable($arrPlugin, $objPluginInstaller = null) {
        if(file_exists(HTML_REALDIR."plg_tencho")){
            recurse_delete_dir(HTML_REALDIR."plg_tencho");
        }

        $objQuery = new SC_Query();
		$dtb_csv_sql = 'dtb_csv_sql';
		$exist = $objQuery->exists($dtb_csv_sql, "sql_name = '".self::SQL_NAME."'");
		if ($exist){
			$res  = $objQuery->delete($dtb_csv_sql, "sql_name = '".self::SQL_NAME."'");
        }
        $exist = $objQuery->exists($dtb_csv_sql, "sql_name = '".self::SQL_NAME_OP."'");
		if ($exist){
			$res  = $objQuery->delete($dtb_csv_sql, "sql_name = '".self::SQL_NAME_OP."'");
		}
	}

	/**
     * 処理の介入箇所とコールバック関数を設定
     * registerはプラグインインスタンス生成時に実行されます
     *
     * @param SC_Helper_Plugin $objHelperPlugin
     * @return void
     */
	//function register(SC_Helper_Plugin $objHelperPlugin) {
    // SC_Plugin_Base::public function register(SC_Helper_Plugin $objHelperPlugin, $priority)
    // => SC_Helper_Plugin::$objPlugin->register($objPluginHelper, $priority);
	function register($objHelperPlugin, $priority) {
        parent::register($objHelperPlugin, $priority);
		//購入確定時にフック。
        $objHelperPlugin->addAction('LC_Page_Shopping_Complete_action_before', array($this, 'LC_Page_Shopping_Complete_action_before'));
        
        
	}

    //購入確定時にフック
	function LC_Page_Shopping_Complete_action_before($objPage) {
        /*
		$order_id = $_SESSION['order_id'];

        $objQuery =& SC_Query_Ex::getSingletonInstance();
        $where = 'order_id = ? AND del_flg = 0';
        $arrOrder = $objQuery->getRow('*', 'dtb_order', $where, array($order_id));
        if (empty($arrOrder)) {
			trigger_error("該当する受注が存在しない。(注文番号: $order_id)", E_USER_ERROR);
        }
        $where = 'order_id = ?';
		$objQuery->setOrder('order_detail_id');
		$arrOrderDetail = $objQuery->select('*', 'dtb_order_detail', $where, array($order_id));
        
        echo "</br><pre>";
        var_dump($arrOrderDetail);
        echo "</pre>";
        */
    }

     
  
}


function recurse_copy_dir($src, $dest) {
     $count = 0;
     // ensure that $src and $dest end with a slash so that we can concatenate it with the filenames directly
     $src = rtrim($src, "/\\") . "/";
     $dest = rtrim($dest, "/\\") . "/";
 
     // use dir() to list files
     $list = dir($src);
 
     // create $dest if it does not already exist
     @mkdir($dest);
 
     // store the next file name to $file. if $file is false, that's all -- end the loop.
     while(($file = $list->read()) !== false) {
         if($file === "." || $file === "..") continue;
         if(is_file($src . $file)) {
             copy($src . $file, $dest . $file);
             $count++;
         } elseif(is_dir($src . $file)) {
             $count += recurse_copy_dir($src . $file, $dest . $file);
         }
     }
 
     return $count;
 }

 function recurse_delete_dir($src) {
     $count = 0;
     // ensure that $src and $dest end with a slash so that we can concatenate it with the filenames directly
     $src = rtrim($src, "/\\") . "/";
 
     // use dir() to list files
     $list = dir($src);
 
     // store the next file name to $file. if $file is false, that's all -- end the loop.
     while(($file = $list->read()) !== false) {
         if($file === "." || $file === "..") continue;
         if(is_file($src . $file)) {
             unlink($src . $file);
             $count++;
         } elseif(is_dir($src . $file)) {
             $count += recurse_delete_dir($src . $file);
         }
     }
 
     rmdir($src);
     return $count;
 }

 function makeRandString($length)  
{  
    $characters  = "0123456789";  
    $characters .= "abcdefghijklmnopqrstuvwxyz";  
    $characters .= "ABCDEFGHIJKLMNOPQRSTUVWXYZ";  
      
    $string_generated = "";  
      
    $nmr_loops = $length;  
    while ($nmr_loops--)  
    {  
        $string_generated .= $characters[mt_rand(0, strlen($characters) - 1)];  
    }  
      
    return $string_generated;  
}  

?>
