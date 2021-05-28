<?php


class plugin_update { 
    /**
    * アップデート
    * updateはアップデート時に実行されます.
    * 引数にはdtb_pluginのプラグイン情報が渡されます. *
    * @param array $arrPlugin プラグイン情報の連想配列(dtb_plugin)
    * @return void */
    function update($arrPlugin) { 
        if(file_exists(PLUGIN_UPLOAD_REALDIR."EcTenchoApi")){
            self::recurse_delete_dir(PLUGIN_UPLOAD_REALDIR."EcTenchoApi");
        }
        self::recurse_copy_dir(DOWNLOADS_TEMP_PLUGIN_UPDATE_DIR,PLUGIN_UPLOAD_REALDIR."EcTenchoApi");
        if(file_exists(HTML_REALDIR."plg_tencho")){
            self::recurse_delete_dir(HTML_REALDIR."plg_tencho");
        }
        if($arrPlugin["enable"] == "1"){
            self::recurse_copy_dir(PLUGIN_UPLOAD_REALDIR."EcTenchoApi/plg_tencho", HTML_REALDIR."plg_tencho");
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
                $count += self::recurse_copy_dir($src . $file, $dest . $file);
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
                $count += self::recurse_delete_dir($src . $file);
            }
        }
    
        rmdir($src);
        return $count;
    }

    function recurse_show_dir($src) {
        $count = 0;
        // ensure that $src and $dest end with a slash so that we can concatenate it with the filenames directly
        $src = rtrim($src, "/\\") . "/";
    
        // use dir() to list files
        $list = dir($src);
    
        // store the next file name to $file. if $file is false, that's all -- end the loop.
        while(($file = $list->read()) !== false) {
            if($file === "." || $file === "..") continue;
            if(is_file($src . $file)) {
                var_dump($src . $file);
                $count++;
            } elseif(is_dir($src . $file)) {
                $count += self::recurse_show_dir($src . $file);
            }
        }
    
        return $count;
    }
}

?>

