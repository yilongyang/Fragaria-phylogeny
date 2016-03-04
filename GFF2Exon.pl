#extract the exones coordinate info for load it into DB
open(FH,"$ARGV[0]")||die "Uto file1 GFF3 file: $!\n";
while(defined($line=<FH>)){
	chomp$line;
	if($line=~/CDS/ and $line=~/^LG/){
		@temp=split("\t",$line);
		$lg=$temp[0];
		$start=$temp[3];
		$end=$temp[4];
		print "$lg\t$start\t$end\n";
	}
}
	