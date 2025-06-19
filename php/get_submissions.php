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

$sql = "SELECT 
            s.id AS submission_id, 
            w.title AS task_title, 
            s.submitted_at, 
            SUBSTRING(s.submission_text, 1, 100) AS submission_preview 
        FROM tbl_submissions s 
        JOIN tbl_works w ON s.work_id = w.id 
        WHERE s.worker_id = '$worker_id' 
        ORDER BY s.submitted_at DESC";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $submissionArray = array();
    while ($row = $result->fetch_assoc()) {
        $submissionArray[] = $row;
    }
    $response = array('status' => 'success', 'data' => $submissionArray);
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
