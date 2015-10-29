#!C:\wamp\bin\perl\bin\perl.exe
# PERL MODULES WE WILL BE USING
use CGI;
use DBI;
use DBD::mysql;
require "cgi-lib.pl";


# Config DB variables
our $platform = "mysql";
our $database = "registration";
our $host = "localhost";
our $port = "3306";
our $tablename = "coupons";
our $user = "test";
our $pw = "test";
our $q = new CGI;

# DATA SOURCE NAME
$dsn = "dbi:mysql:$database:localhost:3306";

# PERL DBI CONNECT
$connect = DBI->connect($dsn, $user, $pw);

#Get the parameter from your html form.
my $coupon=$q->param('InputcouponName');

my $startdate=$q->param('InputcouponSdate');

my $enddate=$q->param('InputcouponEdate');



print $q->header; 


$sql="INSERT INTO registration.coupons(couponName,startdate,enddate) values('$coupon','$startdate','$enddate')";
$sth = $connect->prepare($sql)
or die "Can't prepare $sql: $connect->errstrn";
#pass sql query to database handle..

$rv = $sth->execute

or die "can 't execute the query $sql : $sth->errstrn";
#execute your query

if ($rv==1){
print<<EIOIFE;


		<html>
		<head>	
		</head>
		<body>
		<div class="container">

			<div class="page-header">
    			<h1>Coupon generated Sucessfully </h1>
			</div>
        </div>		
		
		</body>
		</html>
		
EIOIFE
}else{
print<<EIOIFE;



		<html>
		<head>
		</head>
		<body>
		Error occured in coupon generation
		</body>
		</html>
		
EIOIFE
exit;
}sss