<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

$submission_id = $_POST['submission_id'];
$updated_text = $_POST['updated_text'];

$sql = "UPDATE tbl_submissions 
        SET submission_text = '$updated_text' 
        WHERE id = '$submission_id'";

if ($conn->query($sql) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>