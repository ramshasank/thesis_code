#!C:\wamp\bin\perl\bin\perl.exe
# PERL MODULES WE WILL BE USING
use CGI;
use DBI;
#use DBD::mysql;
require "cgi-lib.pl";

# Config DB variables
our $platform = "mysql";
our $database = "registration";
our $host = "localhost";
our $port = "3306";
our $tablename = "users";
our $user = "test";
our $pw = "test";
our $q = new CGI;

# DATA SOURCE NAME
$dsn = "dbi:mysql:$database:localhost:3306";

# PERL DBI CONNECT
$connect = DBI->connect($dsn, $user, $pw);

#Get the parameter from your html form.

$username=$q->param('username');
$password=$q->param('password');


print $q->header; 

$sql="SELECT * FROM registration.users WHERE  username = '$username' and password = '$password'";
$sth = $connect->prepare($sql)
or die "Can't prepare $sql: $connect->errstrn";
#pass sql query to database handle..

$rv = $sth->execute
or die "can 't execute the query $sql : $sth->errstrn";
#execute your query

# get all the coupons details
$sql="SELECT couponName FROM registration.coupons";
$sth = $connect->prepare($sql)
or die "Can't prepare $sql: $connect->errstrn";
#pass sql query to database handle..

$rvalue = $sth->execute
or die "can 't execute the query $sql : $sth->errstrn";


my @row;
while (@row = $sth->fetchrow_array) {  # retrieve one row

foreach my $column (@row) {
push(@coupons, $column);
}

}

$sql="SELECT usedCoupons FROM registration.users where username = '$username'";
$sth = $connect->prepare($sql)
or die "Can't prepare $sql: $connect->errstrn";
#pass sql query to database handle..

$rvalue = $sth->execute
or die "can 't execute the query $sql : $sth->errstrn";

my @row;
while (@row = $sth->fetchrow_array) {  # retrieve one row

push(@usedCoupons,@row);

}



if ($rv==1){
print<<EIOIFE;


		<html>
		<head>
		<head>
		<script src="./js/cookie.js"></script>
		<script>		
			function urlredirection() {
			createCookie("userSession","$username");
			var usedCoupons = '@usedCoupons'.split(" ");
			allavailableCoupons= '@coupons'	
			for (var i=0 ;i<usedCoupons.length; i++ ){
			
			allavailableCoupons = allavailableCoupons.replace(usedCoupons[i]," ");
			}
			
			
			createCookie("rx",allavailableCoupons);
			
	    	window.location.href = "./getCoupons.html";
		   }
	
		</script>
	
		</head>
		<body onload="urlredirection()">
	
		</html>
		
EIOIFE
}else{
print<<EIOIFE;



		<html>
		<head>
			  <script>		
			function urlredirection() {
	    	 window.location.href = "./custlogin.html?flag=errorLogin";
		    }
	
		</script>
	
		</head>
		<body onload="urlredirection()">
		</body>
		</html>
		
EIOIFE
exit;
}