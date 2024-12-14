<?php
$conn = new mysqli('localhost', 'web_user', 'StrongPassword123', 'web_db');

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

echo "Connected successfully<br>";
echo "Your IP Address: " . $_SERVER['REMOTE_ADDR'] . "<br>";
echo "Current Time: " . date('Y-m-d H:i:s');
?>