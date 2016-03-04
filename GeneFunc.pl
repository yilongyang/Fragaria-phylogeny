#extract the gene function from the fna file for MySQL input
open(FNA,"$ARGV[0]")||die "Uto file1 fvesca_v1.0_genemark_hybrid.annotated.fna $!\n";
while(defined($line=<FNA>)){
chomp $line;
	if($line=~/^>/){
	$line=~/>(.*?)-hybrid/;
	$geneid=$1."-hybrid";
	$geneid=~s/\s+//g;
	$line=~s/>$geneid//;
	$func=$line;
	
	print "$geneid\t$func\n";
	}
	
}

	