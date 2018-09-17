<!DOCTYPE html>  
<head>
  <title>UPDATE PostgreSQL data with PHP</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <style>li {list-style: none;}</style>
</head>
<body>
	<h2>Create book</h2>
    <ul>
        <form name="display" action="index.php" method="POST" >
			<li>Book ID:</li>
            <li><input type="text" name="bookid" placeholder="bookid" required/></li>
			<li>Book Name:</li>
            <li><input type="text" name="name" placeholder="name" required/></li>
			<li>Book Price:</li>
            <li><input type="text" name="price" /></li>
			<li>Book Date:</li>
			<li><input type="text" name="date" /></li>
			<li><input type="submit" name="createEntry" /></li>
        </form>
    </ul>

  <h2>Supply bookid and enter</h2>
  <ul>
    <form name="display" action="index.php" method="POST" >
      <li>Book ID:</li>
      <li><input type="text" name="bookid" /></li>
      <li><input type="submit" name="submit" /></li>
    </form>
  </ul>

  <h2>Delete book by Id</h2>
	  <ul>
		<form name="display" action="index.php" method="POST" >
			<li>Book ID:</li>
			<li><input type="text" name="bookidDelete" /></li>
			<li><input type="submit" name="bookidToDelete" /></li>
		</form>
	  </ul>

  <?php
  	// Connect to the database. Please change the password in the following line accordingly
    $db     = pg_connect("host=localhost port=5432 dbname=postgres user=postgres password=password");
    $result = pg_query($db, "SELECT * FROM book where id = '$_POST[bookid]'");		// Query template
    $row    = pg_fetch_assoc($result);		// To store the result row

	if($db){
		echo "129!";
	} else {
		echo "failed";
	}

    if (isset($_POST['createEntry'])) {
        $query = "INSERT INTO book VALUES ('$_POST[bookid]', '$_POST[name]', '$_POST[price]', '$_POST[date]')";
            $result = pg_query($db, $query);
            if (!$result) {
                echo "failed!";
            }
            else {
				$row = pg_fetch_assoc($result);
                echo "inserted" + $result[bookid];
            }
    }
	
    if (isset($_POST['submit'])) {
		$result = pg_query($db, "SELECT * FROM book where id = '$_POST[bookid]'");		// Query template
		$row    = pg_fetch_assoc($result);		// To store the result row
        echo "<ul><form name='update' action='index.php' method='POST' >  
    	<li>Book ID:</li>  
    	<li><input type='text' name='bookid_updated' value='$row[id]' /></li>  
    	<li>Book Name:</li>  
    	<li><input type='text' name='book_name_updated' value='$row[name]' /></li>  
    	<li>Price (USD):</li><li><input type='text' name='price_updated' value='$row[price]' /></li>  
    	<li>Date of publication:</li>  
    	<li><input type='text' name='dop_updated' value='$row[publicationdate]' /></li>  
    	<li><input type='submit' name='new' /></li>  
    	</form>  
    	</ul>";
    }
	
    if (isset($_POST['new'])) {	// Submit the update SQL command
		$q = "UPDATE book SET id = '$_POST[bookid_updated]',  
								name = '$_POST[book_name_updated]',
								price = '$_POST[price_updated]',  
								publicationdate = '$_POST[dop_updated]' 
								WHERE id = '$_POST[bookid_updated]'";
        $result2 = pg_query($db, "UPDATE book SET id = '$_POST[bookid_updated]',  
								name = '$_POST[book_name_updated]',
								price = '$_POST[price_updated]',  
								publicationdate = '$_POST[dop_updated]' 
								WHERE id = '$_POST[bookid_updated]'") or die($q . pg_last_error());

        if (!$result2) {
            echo "Update failed!!";
        } else {
            echo "Update successful!";
        }
    }
	
	if (isset($_POST['bookidToDelete'])) {
        $query2 = "DELETE FROM book WHERE id = '$_POST[bookidDelete]' ";
            $result3 = pg_query($db, $query2);
            if (!$result3) {
                echo "failed!";
            }
            else {
				$row = pg_fetch_assoc($result3);
                echo "DELETED";
            }
    }
    ?>  
</body>
</html>
