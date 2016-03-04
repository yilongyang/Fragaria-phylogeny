
for($k=0;$k<=$ARGV[2];$k++){
$query="$k"."-$ARGV[0]";

$out="$ARGV[0]blastout-$k.txt";
print "$query\n";
system "blastn -db $ARGV[1] -query $query -outfmt 7 -evalue 0.5 -word_size 11 -out $out";
print "====\n";
}


