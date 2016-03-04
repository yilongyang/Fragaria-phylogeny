#add gene function into gene list
#!/usr/bin/perl
use strict;
use warnings;
#make connection with mysql database

use DBI;

my $database ="homo";
my $server="localhost";
my $user='root';
my $passwd='tmdavis';

my $homo=DBI->connect("dbi:mysql:$database:$server",$user,$passwd,{RaiseError=>1});
#prepare an SQL statement
my $query="show tables";
my $sql=$homo->prepare($query);
#execute an SQL statement
$sql->execute();
open(LS,"$ARGV[0]")||die "Uto file1 Gene List file, with gene id in the first column $!\n";

my $line;
my $geneid;
my $table;
my $subject;
my @mysql;
while(defined($line=<LS>)){
chomp$line;
	if($line=~/^>/){
		$line=~/>(.*?)-hybrid/;
		$geneid=$1."-hybrid";
		$query="select genefunc from genefunc where geneid='$geneid'";
	
			$sql=$homo->prepare($query);
			$sql->execute();
			if(my $row=$sql->fetchrow_arrayref){
			$subject=join("",@$row);
			
			print "$line|$subject";
			}

	}else{
		print "$line\n";
	}
	
}


			