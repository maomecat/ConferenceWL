<?php

//connect to DB
mysql_connect("rtiosappdb.db.11208285.hostedresource.com", "rtiosappdb", "AppikonSoft!23");
mysql_select_db("rtiosappdb");

//CAll the [assed in function 
if (function_exists($_GET['method'])) {
	if($_GET['method'] == 'signup')
	{
	 	$_GET['method']($_GET['firstname'], $_GET['lastname'], $_GET['email'], $_GET['password']);
	} elseif($_GET['method'] == 'login') {
		$_GET['method']($_GET['email'], $_GET['password']);
	} elseif($_GET['method'] == 'getProgrammesForUser') {
		$_GET['method']($_GET['userid']);
	} elseif($_GET['method'] == 'setRSVPForUser') {
		$_GET['method']($_GET['userid'], $_GET['programmeid']);
	} elseif($_GET['method'] == 'getAttendeesForProgramm') {
		$_GET['method']($_GET['programmeid']);
	} elseif($_GET['method'] =='checkUserRSVP') {
		$_GET['method']($_GET['programme'], $_GET['user']);
	} else {
		$_GET['method']();
	}
}

function signup($firstname, $lastname, $email, $password) {

	//First check if user exists
	if (checkIfUserExists($email))
	{
		$result = array ("success"=>"false",
					"message"=>"We found an account with this email address. Please login with your credentials");
	} else {
		//Then insert into database if user doesn't exists
		$sql = "INSERT INTO users (firstname, lastname, email, password) VALUES ('$firstname', '$lastname', '$email', '$password')";
 
		$retval = mysql_query($sql);
	
		if(!$retval) {
			$result = array("success"=>"false",
							"message"=>"Could not create account. Please try again later.");
		} else {
			$result = array("success"=>"true");
		}
	}
	echo json_encode($result);
}

function login($email, $password) {
	$result;	
	if(checkIfUserExists($email)) {
		//Username exists in DB
		$sql = "SELECT * FROM users WHERE email='$email' AND password='$password'";
		$retval = mysql_query($sql);
		
		$users = array();
		while($user = mysql_fetch_assoc($retval)) {
			$users = $user;
		}		

		if(count($users) > 0) {
			$result = array("success"=>"true",
						"user"=> $users);
		} else {
 			$result = array("success"=>"false",
 							"message"=>"Password is not correct.");
		}
	} else {
		//Username doesnt exists in DB
		$result = array("success"=>"false",
						"message"=>"No account found with this email. Please make sure you entered correct email.");
	}
	echo json_encode($result);
}

function getAllUsers() {
	$user_sql = mysql_query("select * from users");
	$users = array();
	while($user = mysql_fetch_assoc($user_sql)) {
		$users[] = $user;
	}
	$users = json_encode($users);
	header("Content-type:application/json");
	echo $users;
}

function getAllProgrammes() {
	$prog_sql = mysql_query("select * from programmes");
	$programmes = array();
	while($program = mysql_fetch_assoc($prog_sql)) {
		$programmes[] = $program;
	}
	$programmes = json_encode($programmes);
	header("Content-type:application/json");
	echo $programmes;
}

function setRSVPForUser($userid, $programmeid) {
	$sql = "INSERT INTO user_programmes (userid, programmeid) VALUES ('$userid', '$programmeid')";
 
	$retval = mysql_query($sql);

	if(!$retval) {
		$result = array("success"=>"false",
						"message"=>"Could not create account. Please try again later.");
	} else {
		$result = array("success"=>"true");
	}
	echo json_encode($result);
}

function getProgrammesForUser($user) {
	$sql =  "SELECT * FROM programmes WHERE id IN (SELECT programmeid FROM user_programmes WHERE userid = '$user')";
	$prog_sql = mysql_query($sql);
	$progs = array();
	while($prog = mysql_fetch_assoc($prog_sql)) {
		$progs[] = $prog;
	}
	echo json_encode($progs);	
}

function getAttendeesForProgramm($programm) {
	$sql =  "SELECT * FROM users WHERE id IN (SELECT userid FROM user_programmes WHERE programmeid = '$programm')";
	$attendees_sql = mysql_query($sql);
	$attendees = array();
	while($attend = mysql_fetch_assoc($attendees_sql)) {
		$attendees[] = $attend;
	}
	echo json_encode($attendees);
}

function checkUserRSVP($program, $userid)
{
	$sql = "SELECT * FROM user_programmes WHERE userid = '$userid' AND programmeid = '$program'";
 
	$retval = mysql_query($sql);
	if(mysql_fetch_array($retval) != false)
	{
		$result = array("success"=>"true");
	}
	else
	{
		$result = array("success"=>"false");
	}

	echo json_encode($result);
}

function checkIfUserExists($email)
{
	$sql = "SELECT * FROM users WHERE email='$email' LIMIT 1";
	$result = mysql_query($sql);
	if (mysql_fetch_array($result) != false) {
		return true;
	} else {
		return false;
	}
}
?>