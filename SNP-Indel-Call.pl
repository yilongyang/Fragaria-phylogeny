open(BAM,$ARGV[0])||die "Uto BAM or SAM file to work with: $!\n";

$k=0;
while(defined($line=<BAM>)){
#print "$line\n";
	if($k>500){
		foreach my $key ( sort { $a <=> $b} keys %var ) {
			if($var{$key}>1){
				print "$key\t$var{$key}\n";
				delete $var{$key};
			}
		}
		$k=0;
	}	




@temp=split("\t",$line);
$lg=$temp[2];
$readname="$temp[0]-$lg";

$start=$temp[3];
$mapq=$temp[4];
$cigar=$temp[5];
$matelg=$temp[6];
$matestart=$temp[7];
$readseq=$temp[9];
$tail=scalar@temp;
$md=$temp[$tail-1];
	if ($md!~/^MD/){
		$md=$temp[$tail-2];
	}

$md=~s/MD:Z://g;

	if($cigar=~/[A-Z]/ and $mapq>20){
		$y=$cigar=~s/(\d+)([A-Z])/$1-$2-/g;
		@cigarop=split("-",$cigar);
		$length=0;
		$readhash{$readname}="";
		$substart=0;
		for($i=0; $i<=scalar@cigarop;$i++){
	         if($cigarop[$i+1]=~/M/){ 
                 $length=$length+$cigarop[$i];
				 $alignread=$alignread.substr($readseq,$substart,$cigarop[$i]);
				 $substart=$substart+$cigarop[$i];
				 }elsif($cigarop[$i+1]=~/D/){
				 $length=$length+$cigarop[$i];
				 $delete="N"x$cigarop[$i];
				 $alignread=$alignread.$delete;
				 
                }elsif($cigarop[$i+1]=~/I/){
				 $substart=$substart+$cigarop[$i];
				$loc=$start+$length;
				$key="$loc-$lg-($cigarop[$i]-I)";
				     if(!exists $var{$key}){
			              $var{$key}=1;
					 }else{
                          $var{$key}=$var{$key}+1;
  						}  
			    
				}elsif($cigarop[$i+1]=~/S/){
				 $substart=$substart+$cigarop[$i];
				 }
		}		
				
$length=0;	
        #print "$line\n";			
		#print "$readseq\t$alignread\n";
			


    if($md=~/[A-Z]/){
                $md=~s/(\d+)/-$1-/g;
				$md=~s/(\^)//g;
                @mdstring=split("-",$md);
				shift@mdstring;
				foreach$mdstring(@mdstring) {
				    if($mdstring=~/\d+/){
					
					$length=$length+$mdstring;
					
					}elsif($mdstring=~/[A-Z]/){
					       $snpstart=$start+$length;
						   $snpend=$start+$length+length($mdstring)-1;
						   #print "$snpstart\t$snpend\n";
						   @snptemp=($snpstart..$snpend);
						 
						   $number=scalar@snptemp;
						 $l=0;
						         foreach $snptemp(@snptemp){
								 $varstart=$length+$l;
								      $readvar=substr($alignread,$varstart,1);
									  $key="$snptemp-$lg-ALT-$readvar";
									  #print "$line\n";
									  #print "$key\n";
				                      if(!exists $var{$key}){
			                              $var{$key}=1;
					                   }else{
                                          $var{$key}=$var{$key}+1;
									  }
									 $l++;  
									 #print "$readname\t$start\t$mdstring\t$key\n";
									}
									
                         $length=$length+length($mdstring);
                    }
				}
	}
	

$insertloc="";
$snploc="";
	$alignread="";
}
}
$k=$k+1;




}
  