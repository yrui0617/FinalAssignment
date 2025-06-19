<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

$worker_id = $_POST['worker_id'];
$worker_name = $_POST['worker_name'];
$worker_email = $_POST['worker_email'];
$worker_phone = $_POST['worker_phone'];
$worker_address = $_POST['worker_address'];

$sql = "UPDATE tbl_workers SET 
            worker_name = '$worker_name', 
            worker_email = '$worker_email', 
            worker_phone = '$worker_phone', 
            worker_address = '$worker_address' 
        WHERE worker_id = '$worker_id'";

if ($conn->query($sql) === TRUE) {
    $response = array("status" => "success", "data" => null);
} else {
    $response = array("status" => "failed", "data" => null);
}
sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>