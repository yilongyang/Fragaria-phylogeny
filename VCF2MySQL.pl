#extract the SNP and InDel informationfrom VCF file for MySQL input
open(VCF,"$ARGV[0]")||die "Uto Variant Calling VCF file: $!\n";
while(defined($line=<VCF>)){
	chomp$line;
	if($line=~/^LG/){
		@temp=split("\t",$line);
		$lg=$temp[0];
		$pos=$temp[1];
		$ref=$temp[3];
		$alt=$temp[4];
		$reflength=length$ref;
		$altlength=length$alt;
		if($reflength==1 and $altlength==1){
			print "Mandshurica\t$lg\t$pos\n";
		}else{
			if($reflength>$altlength){
				$start=$pos+1;
				$end=$pos+$reflength-1;
				@del=($start..$end);
				foreach $del(@del){
					print "Mandshurica\t$lg\t$del\n";
				}	
			}else{
				print "Mandshurica\t$lg\t$pos\n";
			}	
		}
	}
}
	