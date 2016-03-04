#add base depth infor to alu or hae site text
open(SITE, "YW-PA-ALU-Depth-Sorted.txt")||die "Uto : Integrated YW and PA site File$!\n";
open(ADD, ">>YW-PA-ALU-add.txt")||die "Uto : Integrated YW and PA site File with site depth and base depth$!\n";
while(defined($line=<SITE>)){
chomp$line;
$ywpaline=$line;
@temp=split("\t",$line);
$loc="$temp[1]-$temp[2]";
#print "ALU $ywpaline\n";
 
             		
			open(PA, "PA-Basedepth.txt")||die "Uto : PA ALU site loc and depth file$!\n";
          
          
                while(defined($paline=<PA>)){
				  chomp $paline;
                 @patemp=split("\t",$paline);
                 @pabase=split("-",$patemp[0]);
                          if($temp[1]=~/$pabase[0]/ and $temp[2]==$pabase[1]){

						print ADD "$temp[0]\t$temp[1]\t$temp[2]\t$temp[3]\tPA\t$patemp[1]";						  last;
                                                  
						  }

						  
				}
                  
		 close PA;
 open(YW, "YW-Basedepth.txt")||die "Uto : YW ALU site loc and depth file$!\n";
                while(defined($ywline=<YW>)){
				  chomp $ywline;
@ywtemp=split("\t",$ywline);
@ywbase=split("-",$ywtemp[0]);

                          if($temp[1]=~/$ywbase[0]/ and $temp[2]==$ywbase[1]){
#print "YW $ywbase[0]\t$ywbase[1]\n";
						  
						  print ADD "\tYW\t$ywtemp[1]\n";
						  last;
						  }
						  
						  }
			close YW;



			
			
}
			