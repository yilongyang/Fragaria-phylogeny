#Screening out the genes that are single copy in the genome
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
my @RNAblast;
my $RNAblast;
my $i;
my @temp1;
my $header;
my $geneid;
my @firsthit;
my $identity;
my $alnlength;
my $evalue;
my $hitcover;
my $cover;
my $geneseq;
my $rnalength;
my $hitnum;
my $k;
my $blastout;
my $genefunc;

open(FH,">>$ARGV[1]")||die "Uto file1 mRNA-EST blast output extracted file: $!\n";

$blastout=$ARGV[0];
open(PBO,$blastout)||die "Uto file1 mRNA-EST blast output: $!\n";



@RNAblast=<PBO>;
$RNAblast=join("",@RNAblast);
@RNAblast=split("# BLASTN 2.2.26+",$RNAblast);
print scalar@RNAblast,"\n";




shift@RNAblast;
for($i=0;$i<scalar@RNAblast;$i++){


@temp1=split("\n",$RNAblast[$i]);

if($temp1[3]=~/Fields/){
	$temp1[1]=~/Query:(.*?)$/;
	$header="$1";
	#print "$header\n";
	$header=~/^(.*?)-hybrid/;
	$geneid=$1."-hybrid";
	$header=~/(\s+)(\d+)_nt/;
	$rnalength=$2;
	#print "$geneid\n";
	$geneid=~s/\s+//g;
	#$header=~/hybrid(.*?)$/;
	#$genefunc=$1;

		@firsthit=split("\t",$temp1[5]);

		
		$identity=$firsthit[2]/100;
		$alnlength=$firsthit[3];
		$evalue=$firsthit[10];
		$hitcover=$identity*$alnlength/$rnalength;
		$cover=sprintf("%0.2f",$hitcover);

		if($hitcover>0.5){
		
			$query="select seq from geneseq where geneid='$geneid'";
			$sql=$homo->prepare($query);
			$sql->execute();
			if(my $row=$sql->fetchrow_arrayref){
				$geneseq=join("\t",@$row);
				if(length($geneseq)>900){
				print FH ">$geneid|$rnalength|$cover|\n";
				print FH "$geneseq\n";
				}
			}
		}
	
	}	

}
close PBO;








__END__								


while(defined($line=<PBO>)){
chomp($line);

         if($line=~ /Query/){
				 @head=split(qw(LOC),$line);
				@splithead=split(" ",$head[1]);
				$rightlimit=$splithead[4]-50;
				$leftlimit=$splithead[2]+50;
          }elsif($line=~ /hits found/){
                           @temp=split(" ",$line);
						   $x=$temp[1];
						   }
						   
						   
				           if($x<4){
           						   print SCR ">LOC $head[1]\n";
							}
	         }
			 
		
}
