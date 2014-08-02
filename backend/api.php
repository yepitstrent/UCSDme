<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');

/*function get_pois()
{
  $con=mysqli_connect("p:localhost", "root", "password", "ucsdme");
  // Check connection
  if (mysqli_connect_errno())
  {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

  $arr = array();

  $rs=mysqli_query($con,"SELECT name FROM pois");
  while($obj = mysqli_fetch_object($rs))
  {
    $arr[] = $obj->name;
  }
  return $arr;
}
*/

function get_pois()
{
  $con=mysqli_connect("p:localhost", "root", "password", "ucsdme");
  // Check connection
  if (mysqli_connect_errno())
  {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

  $arr = array();

  $query = sprintf("SELECT * FROM pois");
  $rs=mysqli_query($con, $query);
  while($obj = mysqli_fetch_object($rs))
  {
    $arr[] = $obj;
  }

  return $arr;
}

function get_categories()
{
  $con=mysqli_connect("p:localhost", "root", "password", "ucsdme");
  // Check connection
  if (mysqli_connect_errno())
  {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

  $arr = array();

  $query = "select name from categories";
  $rs=mysqli_query($con, $query);
  while($obj = mysqli_fetch_object($rs))
  {
    $arr[] = $obj->name;
  }
  return $arr;
}

/********************************************************************
 *
 *******************************************************************/
function get_pois_by_categories($category)
{
  $con=mysqli_connect("p:localhost", "root", "password", "ucsdme");
  // Check connection
  if (mysqli_connect_errno())
  {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

  $varArr = explode("_", $category);

  $el = $varArr[0];

  $query = sprintf("(select p.name from pois p, poiToCategory ptc, categories c where ptc.poi_id = p.poi_id AND c.cat_id = ptc.cat_id AND c.name = '%s')",  mysqli_real_escape_string($con, $el));
  unset($varArr[0]);

  $unionStr;

  foreach($varArr as &$element)
  {
    $unionStr = sprintf(" union (select p.name from pois p, poiToCategory ptc, categories c where ptc.poi_id = p.poi_id AND c.cat_id = ptc.cat_id AND c.name = '%s')",  mysqli_real_escape_string($con, $element));
    $query = $query . $unionStr;
  }

  $arr = array();

  $rs=mysqli_query($con, $query);
  while($obj = mysqli_fetch_object($rs))
  {
    $arr[] = $obj->name;
  }
  return $arr;
}


function insert_facebook_id($facebook_id, $name, $lat, $lon, $alt)
{
  //echo "TRENT AND HANNAH ARE called facebook id method WORKING?";
  $con=mysqli_connect("p:localhost", "root", "password", "ucsdme");
  // Check connection
  if (mysqli_connect_errno())
  {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

  $str = sprintf("insert into facebookID (facebook_id, name, lat, lon, alt) values (%s, \"%s\", %s, %s, %s)",
    mysqli_real_escape_string($con, $facebook_id),
    mysqli_real_escape_string($con, $name),
    mysqli_real_escape_string($con, $lat),
    mysqli_real_escape_string($con, $lon),
    mysqli_real_escape_string($con, $alt) );


  mysqli_query($con, $str);
  $str = sprintf("CREATE EVENT evt_%s ON SCHEDULE AT NOW() + INTERVAL 5 MINUTE DO DELETE FROM facebookID WHERE facebook_id = %s;",
		 mysqli_real_escape_string($con, $facebook_id),
                 mysqli_real_escape_string($con, $facebook_id) );


  return mysqli_query($con, $str);
}

function update_location($facebook_id, $lat, $lon, $alt)
{
  //echo "in here";
  $con=mysqli_connect("p:localhost", "root", "password", "ucsdme");
  // Check connection
  if (mysqli_connect_errno())
  {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

  $str = sprintf("update facebookID set lat = %s, lon = %s, alt = %s where facebook_id = %s",
    mysqli_real_escape_string($con, $lat),
    mysqli_real_escape_string($con, $lon),
    mysqli_real_escape_string($con, $alt),
    mysqli_real_escape_string($con, $facebook_id)
    );

  mysqli_query($con, $str);

  /*mysql>        ALTER EVENT evt_1 ON SCHEDULE AT NOW() + INTERVAL 5 MINUTE;*/
  $str = sprintf("ALTER EVENT evt_%s ON SCHEDULE AT NOW() + INTERVAL 5 MINUTE",
                 mysqli_real_escape_string($con, $facebook_id) );

  return mysqli_query($con, $str);
}

function get_facebook_by_id($facebook_id)
{
  $con=mysqli_connect("p:localhost", "root", "password", "ucsdme");
  // Check connection
  if (mysqli_connect_errno())
  {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

  $tempArr = explode('_', $facebook_id);
  $element = $tempArr[0];

  $str = sprintf("(select * from facebookID where facebook_id = %s)",
                 mysqli_real_escape_string($con, $element));
  unset($tempArr[0]);

  $unionStr;

  foreach($tempArr as $unionElement)
  {
    $unionStr = sprintf(" union (select * from facebookID where facebook_id = %s)", mysqli_real_escape_string($con, $unionElement) );
    $str = $str . $unionStr;
  }

  $arr = array();

  $rs = mysqli_query($con, $str);
  while( $obj = mysqli_fetch_object($rs) )
  {
    $arr[] = $obj;
  }

  return $arr;

}

$possible_url = array("get_pois", "get_api_list", "get_pois_by_name",
  "get_categories", "get_pois_by_categories", "insert_facebook_id", "update_location",
  "get_facebook_by_id");

$value = "An error has occurred";

if (isset($_GET["action"]) && in_array($_GET["action"], $possible_url))
{

  switch ($_GET["action"])
  {
  case "get_pois":
    $value = get_pois();
    break;
  case "get_api_list":
    $value = $possible_url;
    break;
  case "get_categories":
    $value = get_categories();
    break;
  case "get_pois_by_name":
    if(isset($_GET["name"]))
      $value = get_pois_by_name($_GET["name"]);
    else
      $value = "Missing argument";
    break;
  case "get_pois_by_categories":
    //echo "<h1>Hello " . $_GET["category"] . "</h1>";
    if(isset($_GET["category"]))
    {
      $value = get_pois_by_categories($_GET["category"]);
    }
    else
    {
      $value = "Missing argument";
    }
    break;
  case "insert_facebook_id":
    //echo "Trent";
    //echo "<h1>Hello</h1>";
    $value = insert_facebook_id($_GET["facebook_id"], $_GET["name"], $_GET["lat"], $_GET["lon"], $_GET["alt"]);

    break;
  case "update_location":

    $value = update_location($_GET["facebook_id"], $_GET["lat"], $_GET["lon"], $_GET["alt"]);

    break;
  case "get_facebook_by_id":
    $value = get_facebook_by_id($_GET["facebook_id"]);

    break;
  /*case "insert_facebook_id":
    if(isset($_GET["facebook_id"] && isset($_GET["name"] && isset($_GET["lat"]
      && isset($_GET["lon"]) && isset($_GET["alt"] && isset($_GET["picture"]) )
    {
      //set value & JSON here
      insert_facebook_id($_GET["facebook_id"], $_GET["name"], $_GET["lat"],
        $_GET["lon"], $_GET["alt"], $_GET["picture"]);

      $value = "Probably inserted that value, guys.";
    }
    else
    {
      $value = "Missing argument";
    }
    break;*/
  }
}


//return JSON array
exit(json_encode($value));
?>




