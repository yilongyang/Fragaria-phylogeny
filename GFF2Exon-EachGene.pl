#extract the exones coordinate info for load it into DB
open(FH,"$ARGV[0]")||die "Uto file1 GFF3 file: $!\n";
while(defined($line=<FH>)){
	chomp$line;
	@temp=split("\t",$line);
	
	if($temp[2]=~/gene/ and $line=~/^LG/){
		
		$line=~/ID=(.*?);/;
		$geneid=$1;
		$genestart=$temp[3];
		$geneend=$temp[4];
		#print "$line\n";
	}elsif($temp[2]=~/CDS/ and $line=~/^LG/){
		
		$cdsstart=$temp[3];
		$cdsend=$temp[4];
		$mstart=$cdsstart-$genestart+1;
		$cdslength=$cdsend-$cdsstart+1;
		print "$geneid\t$mstart\t$cdslength\n";
	}	
	
		
}


