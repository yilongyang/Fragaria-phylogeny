#add base depth infor to alu or hae site text
open(SITE, "YW-PA-ALU-Depth-Sorted.txt")||die "Uto : Integrated YW and PA site File$!\n";
open(ADD, ">>YW-PA-ALU-add.txt")||die "Uto : Integrated YW and PA site File with site depth and base depth$!\n";
while(defined($line=<SITE>)){
chomp$line;
@temp=split("\t",$line);
$loc="$temp[1]-$temp[2]";
 
          open(PA, "PA-ALU-Depth-2.txt")||die "Uto : PA ALU site loc and depth file$!\n";
                while(defined($paline=<PA>)){
				  chomp $paline;
                          if($paline=~/$loc/){
						  @patemp=split("\t",$paline);
						  $line.="\t$patemp[1]";
						  last;
						  }
						  last;
				}
		 close PA;
          	open(YW, "YW-ALU-Depth-2.txt")||die "Uto : PA ALU site loc and depth file$!\n";
                while(defined($ywline=<PA>)){
				  chomp $ywline;
                          if($ywline=~/$loc/){
						  @ywtemp=split("\t",$ywline);
						  print ADD "$line\t$ywtemp[1]\n";
						  last;
						  }
						  last;
						  }
			close PA;
			
			
			
			
}
			