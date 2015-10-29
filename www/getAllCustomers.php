<?php

$con = mysql_connect("localhost","test","test");
if (!$con)
  {
  die('Could not connect: ' . mysql_error());
  }
mysql_select_db("registration", $con);

$result = mysql_query("SELECT * FROM coupons");

while($row = mysql_fetch_assoc($result))
  {
	$output[]=$row;
  }

print(json_encode($output));

mysql_close($con);


?>