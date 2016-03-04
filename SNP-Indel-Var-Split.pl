#split large file into smaller ones
open(VCF,$ARGV[0])||die "Uto Variation file to work with: $!\n";
open(VAR,">>1-$ARGV[0]")||die "Uto Variation file to work with: $!\n";
$k=0;
$i=1;
$lg="LG1";
$lastlg="LG1";
while(defined($line=<VCF>)){
     
	chomp $line;
	@temp=split("-", $line);
	$currentlg=$temp[1];
	

	 if($k>1000 and $currentlg=~/$lastlg/){
	 close VAR;
	 $i++;
	   open(VAR,">>$i-$currentlg-$ARGV[0]")||die "Uto Variation file to work with: $!\n";
     $k=0;
	 }elsif($currentlg!~/$lastlg/){
	  $i=1;
	   open(VAR,">>$i-$currentlg-$ARGV[0]")||die "Uto Variation file to work with: $!\n";
	 $k=0;
	 }
	 
	 
 print VAR "$line\n";
 $lastlg=$currentlg;
 $k++;
 
 } 
 
 close VCF;
 close VAR;
 