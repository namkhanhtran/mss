#!/usr/bin/perl -w 
#This program is to transform the tuples of full tensor TypeDM into Word vector form

#@input: full tensor (tuple) file whose each line looks like
#   word1 link word2 score
#   NOTE: in full tensor file, one word is fully described before moving to another word

#author: Giang Binh Tran (2010)
#It is free software and can be distributed under GNU license, contact: giangtranbinh@gmail.com for information

 


use warnings;
use strict;

if ($#ARGV +1 <2) {
     print "usage: ./tuple_to_wv.pl[space] typeDM_file [space] Output(feature-list)\n";
     exit;
}

my $tensor_file = $ARGV[0];
my $feature_file = $ARGV[1];
print STDERR "Reading the tuples list....\n";
open IN, "<$tensor_file" or die "Cant open the tensor typeDM file for reading";
my %totalfeat = ();
while (<IN>) {
    chomp;
    if ($_ eq "") {last;}
    my ($word, $link, $word2, $score) = split /\s+/, $_;
	my $feature  = $word2."_".$link;
	$totalfeat {$feature} = 1;
}

open OUT, ">$feature_file" or die "Can't open the output $feature_file for writing\n";
my @featlist = keys % totalfeat;
foreach (@featlist) {
	print OUT $_, "\n";
}
close IN;
close OUT;
