#Screening out the primer pairs that target to no more than 3 locs on the ref genome from BLAST output
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

my $seqfile;
my $scrfile;
$seqfile=$ARGV[0]; #Total primers before blast 
open(SEQ, $seqfile)||die "Uto file2 primers sequence: $!\n";
$scrfile="YWPA-Indel-primer-1.fasta";
open(SCR,">>$scrfile")||die "Uto file3 primers sequence after blast filter: $!\n";
my $pbo;
my $k;
my $firstlg;
my $secondlg;
my $thirdlg;


my @primerblast;
my $primerblast;
my @primerseq;
my $primerseq;
my @seq;
my @temp;
my $name;
my %primers;
my $seq;
my $seqs;





@primerseq=<SEQ>;
$primerseq=join("",@primerseq);
@seq=split(">",$primerseq);
print scalar@seq,"\n";

foreach $seq(@seq){
@temp=split("\n",$seq);
$name=shift@temp;

$seqs="$temp[0]\n$temp[1]";
#print "$name\t$seqs\n";
$primers{$name}=$seqs;
}
close SEQ;
my $i;
my $eachblast;
my @temp1;
my $header;
my $hitnum;
my @firsthit;
my $firsthit;
my $leftloc;
my $rightloc;
my @secondhit;
my @head;
my @thirdhit;
my $thirdhit;
my $minus1;
my $minus2;
my $lg;
my $startindel;
my $endindel;
my $filesize;
my $filenum;

$filesize= -s "$ARGV[0]";
$filenum=$filesize/300000;
$filenum=$filenum+2;
for($k=0;$k<$filenum;$k++){
$pbo=$k."blastout-".$ARGV[0];
open(PBO,$pbo)||die "Uto file1 primers blast output: $!\n";

@primerblast=<PBO>;
$primerblast=join("",@primerblast);
@primerblast=split("# BLASTN 2.2.26+",$primerblast);
print scalar@primerblast,"\n";

	for($i=0;$i<scalar@primerblast;$i++){

		$eachblast=$primerblast[$i];
		@temp1=split("\n",$eachblast);

		@head=split(qw(Query:),$temp1[1]);
		$header=$head[1];
		$header=~s/\s+//g;
		
			@head=split("=",$header);
			$lg=$head[0];
			$startindel=$head[2];
			$endindel=$head[3];
			
		
		$temp1[4]=~s/\s+//g;
		$temp1[4]=~/#(\d+)hit/;
		$hitnum=$1;				
#print "$header\t$hitnum\n";

		@firsthit=split("\t",$temp1[5]);
		$firstlg=$firsthit[1];
#print "$hitnum\n";
		$zero="";
		
        if($hitnum==2 and $header!~/PRIMER_PRODUCT/){
			$leftloc="($firsthit[1]-$firsthit[8]-$firsthit[9])";
			@secondhit=split("\t",$temp1[6]);
			$rightloc="($secondhit[1]-$secondhit[8]-$secondhit[9])";
			#print "$firsthit[1]\t$firsthit[8]\t$firsthit[9]\n";
			&zero($lg,$startindel,$endindel);
			if($zero=~/good/){
				print  SCR ">$header-$leftloc-$rightloc\n";
				print  SCR "$primers{$header}\n";										
			}			
		
		}elsif($hitnum==3 and $header!~/PRIMER_PRODUCT/){
			
			@secondhit=split("\t",$temp1[6]);
			$secondlg=$secondhit[1];
			
			@thirdhit=split("\t",$temp1[7]);
			$thirdlg=$thirdhit[1];
			$minus1=abs($firsthit[9]-$secondhit[9]);
			$minus2=abs($firsthit[9]-$thirdhit[9]);
			if($minus1>1500 and $minus2>1500){
				$leftloc="($thirdhit[1]-$thirdhit[8]-$thirdhit[9])";
				$rightloc="($secondhit[1]-$secondhit[8]-$secondhit[9])";
				print "Minus\t$minus1\t$minus2\n";
		
			}elsif($minus2>1500 and $minus1<1500){
				$leftloc="($firsthit[1]-$firsthit[8]-$firsthit[9])";
				$rightloc="($secondhit[1]-$secondhit[8]-$secondhit[9])";
				
			}elsif($minus2<1500 and $minus1>1500){
				$leftloc="($thirdhit[1]-$thirdhit[8]-$thirdhit[9])";
				$leftloc="($firsthit[1]-$firsthit[8]-$firsthit[9])";
					
		
			}elsif( $firstlg=~/$secondlg/ and $firstlg!~/$thirdlg/){
			$leftloc="($firsthit[1]-$firsthit[8]-$firsthit[9])";
			@secondhit=split("\t",$temp1[6]);
			$rightloc="($secondhit[1]-$secondhit[8]-$secondhit[9])";
			#print "$firsthit[1]\t$firsthit[8]\t$firsthit[9]\n";
				
			}
		}
	}
close PBO;
}

close SEQ;
close SCR;

sub zero{
$lg=$_[0];
$startindel=$_[1];
$endindel=$_[2];

$query="select * from  pazerodepth where chromosome='$lg' and position='$startindel'";
				$sql=$homo->prepare($query);
				$sql->execute();
				if(my $row=$sql->fetchrow_arrayref){
				print "Zero detected 1\n";
				}else{
				$query="select * from pazerodepth where chromosome='$lg' and position='$endindel'";
				$sql=$homo->prepare($query);
				$sql->execute();
				if(my $row=$sql->fetchrow_arrayref){
					print "Zero detected 2\n";
					}else{
					
					$query="select * from  ywzerodepth where chromosome='$lg' and position='$startindel'";
					$sql=$homo->prepare($query);
					$sql->execute();
					if(my $row=$sql->fetchrow_arrayref){
					print "Zero detected 3\n";
					}else{
						$query="select * from ywzerodepth where chromosome='$lg' and position='$endindel'";
						$sql=$homo->prepare($query);
						$sql->execute();
						if(my $row=$sql->fetchrow_arrayref){
						print "Zero detected 4\n";
						}else{
					
						$zero="good";
						
						
						}
					}	
				}
			}

return $zero;
}





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
