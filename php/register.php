<html>
<?php
session_start();
include('connect.php');

if(isset($_POST['email']) && isset($_POST['password'])
    && isset($_POST['first_name']) && isset($_POST['last_name'])) {
    $email = $_POST['email'];
    $query = "SELECT * FROM users WHERE email='$email'";
    $result = pg_query($query);
    if (pg_num_rows($result) == 0) {
        $password = password_hash($_POST['password'], PASSWORD_BCRYPT);
        $first_name = $_POST['first_name'];
        $last_name = $_POST['last_name'];
        $query = "INSERT INTO users (email, password, first_name, last_name, is_admin) 
                    VALUES ('$email', '$password', '$first_name', '$last_name', false)";
        pg_query($query);
        $msg = "Successfully registered";
    } else {
        $msg = "A user already exists with this email";
    }
}
?>
    <a href="login.php">Login</a>
    <form method="POST">
        <p>Email</p>
        <input type="text" name="email">
        <p>Password</p>
        <input type="password" name="password">
        <p>First name</p>
        <input type="text" name="first_name">
        <p>Last name</p>
        <input type="text" name="last_name">
        <input type="submit">
    </form>
    <div><?= $msg ?></div>
</html>
