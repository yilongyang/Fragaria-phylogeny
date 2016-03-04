open(BL,$ARGV[0])||die "Uto Gene seq blast output: $!\n";
open(MG,">>$ARGV[1]")||die "Uto genes with multiple hits: $!\n";

@primerblast=<BL>;
$primerblast=join("",@primerblast);
@primerblast=split("# BLASTN 2.2.25+",$primerblast);
print scalar@primerblast,"\n";


for($i=0;$i<scalar@primerblast;$i++){

$eachblast=shift(@primerblast);


@temp1=split("\n",$eachblast);

@head=split(qw(Query:),$temp1[1]);
  $head[1]=~s/\s+//;
	
				
@firsthit=split("\t",$temp1[5]);
$firstalnlength=$firsthit[3];
$fractaln=$firstalnlength/2;
@secondhit=split("\t",$temp1[6]);
$secondalnlength=$secondhit[3];

   if($secondalnlength>$fractaln){
   print MG "$head[1]\n";
   }
   
   
                           			
	}
	
		

close BL;