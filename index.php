<?php
// Database connection parameters
$conn = new mysqli('localhost', 'web_user', 'Str0ng!Passw0rd123', 'web_db');

// Check for connection errors
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Create the 'visits' table if it doesn't exist
$createTableSQL = "CREATE TABLE IF NOT EXISTS visits (
    id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    ip_address VARCHAR(45) NOT NULL,
    visit_time DATETIME DEFAULT CURRENT_TIMESTAMP
)";
$conn->query($createTableSQL);

// Get the visitor's IP address
$visitor_ip = $_SERVER['REMOTE_ADDR'];

// Insert the visitor's IP address into the database
$insertSQL = "INSERT INTO visits (ip_address) VALUES ('$visitor_ip')";
$conn->query($insertSQL);

// Get the current time
$current_time = date('Y-m-d H:i:s');

// Display the information
echo "Connected successfully<br>";
echo "Your IP Address: $visitor_ip<br>";
echo "Current Time: $current_time<br>";

// Close the database connection
$conn->close();
?>
