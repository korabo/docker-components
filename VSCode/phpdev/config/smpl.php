<?php
    echo "Hi, I'm a PHP script!";
    $host1 = gethostname();
    echo "HOSTNAME: gethostname() => " . $host1 . "\n";
    $host2 = php_uname('n');
    echo "HOSTNAME: php_uname('n') => " . $host2;
?>
