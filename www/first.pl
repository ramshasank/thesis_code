#!C:/Perl64/bin/perl -w
require "cgi-lib.pl";
MAIN:
{
	if(&ReadParse(*input))
	 {
		open(FILE, "<encoding(UTF-8)",file.txt);
		print $input{'InputName'}," ",$input{'InputCompanyName'}," ",$input{'InputAddress'};
		close(FILE);
		print<<EIOIFE;
content-Type: text(htm); charset=utf-8


		<html>
		<head>
		</head>
		<body>
		set input!
		</body>
		</html>
		
EIOIFE
	 }
}