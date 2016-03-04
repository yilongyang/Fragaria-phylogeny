#Extract DNA sequences for all the predicted genes.
open(GFF,$ARGV[0])||die "Uto gene prediction file GFF3: $!\n";

while(defined($line=<GFF>)){
	chomp$line;
	@temp=split("\t",$line);
	$type=$temp[2];
	if($type=~/gene/ and $temp[0]=~/LG/){
		$lg=$temp[0];
		$strand=$temp[6];
	
		$start=$temp[3]-1;
		$end=$temp[4];
		$length=$end-$start;
		$temp[8]=~/=(.*?)\;/;
		$geneid=$1;
		open(LG,"$lg.txt")||die "Uto  genome sequence of linkage group of $lg: $!\n";
			$seq=<LG>;
			$geneseq=substr($seq,$start,$length);
			print "$geneid\t$geneseq\n";
		close LG;
		}
		
}
