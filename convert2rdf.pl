#!/usr/bin/perl

$input = "otu_table_with_taxonomy.otu";
$output = "otu_table.ttl";

open(IN, "<$input");
open(OUT, ">$output");

print OUT "\@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n";
print OUT "\@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .\n";
print OUT "\@prefix dwc:  <http://rs.tdwg.org/dwc/terms/> .\n";
print OUT "\@prefix ecb:  <http://ecobiomics.org/ontology/> .\n\n";

$heading=<IN>;
chomp $heading;
@fields=split /\t/, $heading;
$length=@fields;
$obs=1;
@rank=("kingdom", "phylum", "class", "order", "family", "genus", "species");
while ($line=<IN>) {
  chomp $line;
  @list=split/\t/, $line; ## Collect the elements of this line
  @taxonomy=split/; /, $list[$length-1];
  for ($i=1;$i<$length-1;$i++) {
    if ($list[$i] > 0) {
      print OUT "<http://ecobiomics.org/observations/obs_$obs> a ecb:observation ;\n";
      print OUT "  ecb:sample <http://ecobiomics.org/samples/$fields[$i]> ;\n";
      print OUT "  ecb:OTU \"$list[0]\" ;\n";
      for ($j=0; $j<@taxonomy; $j++) {
        $rankValue = substr($taxonomy[$j], 3);
        print OUT "  dwc:$rank[$j] \"$rankValue\" ;\n";
      }
      print OUT "  ecb:count \"$list[$i]\" .\n";
      print OUT "\n";
      $obs++;
    }
  }
}

close IN;
close OUT;
