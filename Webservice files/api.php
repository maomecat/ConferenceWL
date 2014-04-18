<?php

//connect to DB
mysql_connect("rtiosappdb.db.11208285.hostedresource.com", "rtiosappdb", "AppikonSoft!23");
mysql_select_db("rtiosappdb");

//CAll the [assed in function 
if (function_exists($_GET['method'])) {
	if($_GET['method'] == 'signup')
	{
	 	$_GET['method']($_GET['firstname'], $_GET['lastname'], $_GET['email'], $_GET['password']);
	} else {
		$_GET['method']();
	}
}

function signup($firstname, $lastname, $email, $password) {
	$sql = "INSERT INTO users (firstname, lastname, email, password) VALUES ('$firstname', '$lastname', '$email', '$password')";

	$retval = mysql_query($sql);
	$result;
	if(!$retval) {
		$result = array("success"=>"false");
	} else {
		$result = array("success"=>"true");
	}
	echo json_encode($result);
}

function getAllUsers() {
	$user_sql = mysql_query("select * from attendees");
	$users = array();
	while($user = mysql_fetch_array($user_sql)) {
		$users[] = $user;
	}
	$users = json_encode($users);
	header("Content-type:application/json");
	echo $users;
	//echo $_GET['jsoncallback'] . ')' . $users . ')';
}

function getAllProgrammes() {
	$prog_sql = mysql_query("select * from programmes");
	$programmes = array();
	while($program = mysql_fetch_array($prog_sql)) {
		$programmes[] = $program;
	}
	$programmes = json_encode($programmes);
	header("Content-type:application/json");
	echo $programmes;
}
?>