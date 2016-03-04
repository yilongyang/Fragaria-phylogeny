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
my $k;
my @temp1;
my $header;
my $geneid;
my @firsthit;
my @nexthit;
my $evalue2;
my $infile;
my $evalue;
my $sstart;
my $send;
my $geneseq;
my $lg;
my $bitscore;
my $bitscore2;
my $hitnum;
my $firstlen;
my $nextlen;
my $firstlg;
my $firststart;
my $nextlg;
my $nextstart;

my $genefunc;
open(FH,">>$ARGV[1]")||die "Uto file1 extracted DNA seq from blast output: $!\n";
open(HIT,">>$ARGV[2]")||die "Uto file1 Gene ID and hit number file: $!\n";
	$infile=$ARGV[0];
	open(PBO,$infile)||die "Uto file1 DNA sequence blastn output: $!\n";
	#print "$infile\n";
	@RNAblast=<PBO>;
	$RNAblast=join("",@RNAblast);
	@RNAblast=split("# BLASTN 2.2.26+",$RNAblast);
	for($i=0;$i<scalar@RNAblast;$i++){


		@temp1=split("\n",$RNAblast[$i]);
		#print "First\t$temp1[0]\n";
		#$temp1[1]=~/Query:(.*?)$/;
		#print "$temp1[1]\n";
		$header=$temp1[1];
		$header=~s/# Query: //;
		#print "$header\n";
		$header=~/^(.*?)-hybrid/;
		$geneid=$1."-hybrid";
		print "$geneid\n";
		$geneid=~s/\s+//g;
		if($temp1[3]=~/Fields/){
			@firsthit=split("\t",$temp1[5]);
			$header=$firsthit[0];
			$lg=$firsthit[1];		
			$sstart=$firsthit[8];
			$send=$firsthit[9];
			$evalue=$firsthit[10];
			$bitscore=$firsthit[11];
			$firstlen=$firsthit[3];
			$firstlg=$firsthit[1];
			$firststart=$firsthit[8];
			#print FH scalar@temp1,"Count\n";
			$temp1[4]=~s/\s+//g;
			$temp1[4]=~/#(\d+)hit/;
			$hitnum=$1;
			
				if($hitnum>1 and $hitnum<4){
					@nexthit=split("\t",$temp1[6]);
					$evalue2=$nexthit[10];
					$bitscore2=$nexthit[11];
					$nextlen=$nexthit[3];
					$nextlg=$nexthit[1];
					$nextstart=$nexthit[8];
					print HIT "$geneid\t$hitnum\t$firstlg\t$firststart\t$nextlg\t$nextstart\n";
			  	 if($evalue<1e-15 and 5*$evalue<$evalue2 and $bitscore>6*$bitscore2){
					
					$query="select seq from geneseq where geneid='$geneid'";
					$sql=$homo->prepare($query);
					$sql->execute();
					if(my $row=$sql->fetchrow_arrayref){
						$geneseq=join("\t",@$row);
						print FH ">$header|-$hitnum<$firstlen<$nextlen\n";
						print FH "$geneseq\n";
						}
					}	
				}elsif($hitnum==1){
					if($evalue<1e-15){
						$query="select seq from geneseq where geneid='$geneid'";
						$sql=$homo->prepare($query);
						$sql->execute();
						if(my $row=$sql->fetchrow_arrayref){
						$geneseq=join("\t",@$row);
						print FH ">$header|-$hitnum<$firstlen\n";
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
