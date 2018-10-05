<html>
<?php
session_start();
require('connect.php');

if (isset($_POST['email']) && isset($_POST['password'])) {
    $email = $_POST['email'];
    $password = $_POST['password'];

    $query = "SELECT * FROM users WHERE email='$email'";
    $result = pg_query($query);
    if (pg_num_rows($result) != 1) {
        $msg = "Invalid login";
    } else {
        $row = pg_fetch_assoc($result);
        $hash = $row['password'];
        if (password_verify($password, $hash)) {
            $_SESSION['email'] = $email;
            header("Location: index.php");
        } else {
            $msg = "Invalid login";
        }
    }
    pg_free_result($result);
    pg_close($dbconn);
}

if (isset($_SESSION['email'])) {
    $email = $_SESSION['email'];
    echo "Hello " . $email . "";
}

?>
    <form method="POST">
        <input type="text" name="email" required>
        <input type="password" name="password" required>
        <input type="submit">
        <div><?= $msg ?></div>
    </form>

    <a href="register.php">Register</a>
</html>

