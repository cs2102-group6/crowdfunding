<html>
<h1>CROWDFUNDING!</h1>
<h2>users</h2>
<a href="logout.php">Logout</a>
<?php
session_start();
include('connect.php');
if(!isset($_SESSION['email'])) {
    header("Location: login.php");
}

$query = 'SELECT * FROM users';
$result = pg_query($query);

echo "<table>\n";
while ($line = pg_fetch_assoc($result)) {
    echo "\t<tr>\n";
    foreach ($line as $col_value) {
        echo "\t\t<td>$col_value</td>\n";
    }
    echo "\t</tr>\n";
}
echo "</table>\n";

pg_free_result($result);

pg_close($dbconn);

?>
</html>
