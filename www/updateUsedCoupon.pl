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

$usedCoupon=$q->param('couponCarrier');
$username = $q->param('secretusername');

print $q->header; 

$sql="SELECT usedCoupons FROM registration.users WHERE  username = '$username' ";
$sth = $connect->prepare($sql)
or die "Can't prepare $sql: $connect->errstrn";
#pass sql query to database handle..

$rval = $sth->execute
or die "can 't execute the query $sql : $sth->errstrn";

my @row;
while (@row = $sth->fetchrow_array) {  # retrieve one row

push(@usedCoupons, @row);
}

push(@usedCoupons, $usedCoupon);

#updating barcode to users and coupon tables
 
$sql="SELECT usedBarCodes FROM registration.users ";
$sth = $connect->prepare($sql)
or die "Can't prepare $sql: $connect->errstrn";
#pass sql query to database handle..

$rval = $sth->execute
or die "can 't execute the query $sql : $sth->errstrn";

my @row;
while (@row = $sth->fetchrow_array) {  # retrieve one row

push(@usedBarCodes, @row);
}

 my $flag= true;
 
 my $minimum = 100000000000;
my $maximum = 999999999999;

my $newBarCode ;
     
  
  
 $newBarCode= $minimum + int(rand($maximum - $minimum));
my @matches = grep { /$newBarCode/ } @usedBarCodes;
while(@matches){

if( @matches!= "" && @matches!= null ){

$newBarCode= $minimum + int(rand($maximum - $minimum));
@matches = grep { /$newBarCode/ } @usedBarCodes;
}
}
 
# update user table with the generated barcodes

$sql="SELECT usedBarCodes FROM registration.users WHERE  username = '$username' " ;
$sth = $connect->prepare($sql)
or die "Can't prepare $sql: $connect->errstrn";
#pass sql query to database handle..

$rval = $sth->execute
or die "can 't execute the query $sql : $sth->errstrn";

my @row;
while (@row = $sth->fetchrow_array) {  # retrieve one row

push(@usedBarCodesOfaUser, @row);
}

push(@usedBarCodesOfaUser, $newBarCode);





$sql="Select allBarCodes from registration.coupons WHERE  couponName = '$usedCoupon'";
$sth = $connect->prepare($sql)
or die "Can't prepare $sql: $connect->errstrn";
#pass sql query to database handle..

$rvalue = $sth->execute
or die "can 't execute the query $sql : $sth->errstrn";
#execute your query

my @row;
while (@row = $sth->fetchrow_array) {  # retrieve one row

push(@allBarCodesOfACoupon, @row);
}

push(@allBarCodesOfACoupon, $newBarCode);


$sql="update registration.users set usedCoupons = '@usedCoupons' , usedBarCodes = '@usedBarCodesOfaUser' WHERE  username = '$username'";
$sth = $connect->prepare($sql)
or die "Can't prepare $sql: $connect->errstrn";
#pass sql query to database handle..

$updateUsers = $sth->execute
or die "can 't execute the query $sql : $sth->errstrn";
#execute your query

$sql="update registration.coupons set allBarCodes = '@allBarCodesOfACoupon'  WHERE  couponName = '$usedCoupon'";
$sth = $connect->prepare($sql)
or die "Can't prepare $sql: $connect->errstrn";
#pass sql query to database handle..

$updateCoupons = $sth->execute
or die "can 't execute the query $sql : $sth->errstrn";
#execute your query



if ($updateUsers==1){
print<<EIOIFE;


		<html>
		<head>
		<script src="./js/cookie.js"></script>
		<script>
		function updateCouponDetails(){
		var userName =  readCookie('userSession');
		if (userName == "null" || userName == "undefined" || userName == "" || userName== null){
		
		window.location.href = "./custlogin.html?flag=errorLogin";
		}
		
		var allcoupons = readCookie('rx');
		var usedCouponsElems= '@usedCoupons'.split(" ");
		for (var i=0;i < usedCouponsElems.length;i++){
		allcoupons = allcoupons.replace(usedCouponsElems[i],'');
		}
		
		createCookie("rx",allcoupons);		
		}
		
		function logout(){
		eraseCookie("userSession");
		eraseCookie("rx");
		window.location.href = "./custlogin.html"
		
		}
		</script>
		</head>
		<body onload="updateCouponDetails()">
		You have sucessfully printed the coupon.Your bar code is $newBarCode. 
		
		<input type="button" value="logout"  id="logoutbtn" onclick="logout()"></input>
		</body>
		</html>
		
EIOIFE
}else{
print<<EIOIFE;



		<html>
		<head>
		</head>
		<body>
		Error occured while Printing the coupon.Please print again . 
		</body>
		</html>
		
EIOIFE
exit;
}