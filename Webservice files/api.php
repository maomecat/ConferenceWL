<?php

//connect to DB
mysql_connect("rtiosappdb.db.11208285.hostedresource.com", "rtiosappdb", "AppikonSoft!23");
mysql_select_db("rtiosappdb");

//CAll the [assed in function 
if (function_exists($_GET['method'])) {
	$_GET['method']();
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