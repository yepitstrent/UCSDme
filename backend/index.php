<html>

<body>
<p>Hello CSE190 Team Awesome!!! Here is our awesome webpage. Brad is a little slow..</p>

<p>Here are stats for the server:</p>
<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');
$con=mysqli_connect("p:localhost", "root", "password");
// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$results=mysqli_query($con,"SHOW TABLES FROM ucsdme");

echo "<p>The database has " . $results->num_rows . " table(s) currently</p>";

echo "<ol>";
while($obj = $results->fetch_object())
{
  printf("<li>%s</li>", $obj->Tables_in_ucsdme);
}
echo "</ol>";



$results->close();
mysqli_close($con);
?>

<p>The following api calls are available currently</p>
<ol>
  <li><a href="http://54.200.77.201/api.php?action=get_pois">
              http://54.200.77.201/api.php?action=get_pois</a></li>
  <li><a href="http://54.200.77.201/api.php?action=get_api_list">
              http://54.200.77.201/api.php?action=get_api_list</a></li>
  <li><a href="http://54.200.77.201/api.php?action=get_pois_by_categories&category=Library">
              http://54.200.77.201/api.php?action=get_pois_by_categories&category=Library</a></li>
  <li><a href="http://54.200.77.201/api.php?action=get_pois_by_categories&category=Library_Classrooms_Food">
              http://54.200.77.201/api.php?action=get_pois_by_categories&category=Library_Classrooms_Food</a></li>
   <li><a href="http://54.200.77.201/api.php?action=insert_facebook_id&facebook_id=4&name=sean&lat=1.0&lon=1.0&alt=1.0">
              http://54.200.77.201/api.php?action=insert_facebook_id&facebook_id=4&name=sean&lat=1.0&lon=1.0&alt=1.0 (please change id to be unique)</a></li>  
  <li><a href="http://54.200.77.201/api.php?action=get_facebook_by_id&facebook_id=3">
              http://54.200.77.201/api.php?action=get_facebook_by_id&facebook_id=3</a></li>
  <li><a href="http://54.200.77.201/api.php?action=update_location&facebook_id=3&lon=4.0&lat=4.0&alt=4.0">
              http://54.200.77.201/api.php?action=update_location&facebook_id=3&lon=4.0&lat=4.0&alt=4.0</a></li>
</ol>

</body>
</html>
