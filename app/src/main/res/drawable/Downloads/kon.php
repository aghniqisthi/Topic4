<?php
$con = mysqli_connect('localhost', 'root','');
if(!$con)
{
    die;
}
mysqli_select_db($con,'tes');
?>
