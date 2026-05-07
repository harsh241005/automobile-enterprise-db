<?php
// Using the credentials from your SQL Developer setup
$conn = oci_connect("system", "2330", "localhost/ADBMS");
if (!$conn) {
    $e = oci_error();
    trigger_error(htmlentities($e['message'], ENT_QUOTES), E_USER_ERROR);
}
?>
