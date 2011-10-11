#!/usr/bin/perl
#This program is to transform the tuples of full tensor TypeDM into Word vector form

#@input: full tensor (tuple) file whose each line looks like
#   word1 link word2 score
#   NOTE: in full tensor file, one word is fully described before moving to another word

#@output: word vector: word: word1 score1 word2 score2 word3 score 3

#@storage word vectors: each vector is stored in one file with format:
# filename: word
# line1:   word1 word2 word3 .... wordn
# line2:   link1 link2 link3 .... linkn
# line3:   score1 score2 score3  ...scoren

# words and scoreds are separated by \t (tab) to each others


#usage: ./tuple_to_wv.pl[space] typeDM_file [space] destination_directory_of_outputs
#author: Giang Binh Tran (2010)
#It is free software and can be distributed under GNU license, contact: giangtranbinh@gmail.com for information

#============================ parameters:
# @param_1:  Tuple_list_file {is the file containing list of tuples: word  link  word LMI_score 
# @param_2:  Destination_directory_of_outputs
 


use warnings;
use strict;

if ($#ARGV <1) {
     print "usage: ./tuple_to_wv.pl[space] typeDM_file [space] destination_directory_of_outputs\n";
     exit;
}

my $tensor_file = $ARGV[0];
my $output_dir = $ARGV[1];


if (-d $output_dir) {
	print STDERR "There is a directory named $output_dir!";
}
else {
	print STDERR  "There is a no such directory. The program will create this directory\n";
	mkdir $output_dir;
}
print STDERR "Reading the tuples list....\n";

open IN, "<$tensor_file" or die "Cant open the tensor typeDM file for reading";
my $previous_word = "";
my @wordlist = (); 
my @scorelist = ();
my @linklist = ();

sub print_out {
#This function is to print the description of one w:word to file
#@param: word, wordlist and their scores of co-occurence words
    my @wordlist = @{$_[0]};
    my @scorelist = @{$_[1]};
    my $previous_word = $_[2];
    my $previous_word = lc($previous_word);
	my @linklist = @{$_[3]};
    open OUT, ">", "$output_dir/$previous_word" or die "can't open the $previous_word file to write";
    for (my $i = 0; $i <@wordlist; $i++) { print OUT "$wordlist[$i]_$linklist[$i]\t$scorelist[$i]\n";}
    close OUT;

}
while (<IN>) {
    chomp;
    if ($_ eq "") {last;}
    my ($word, $link, $word2, $score) = split /\s+/, $_;
	# if (substr ($link, length($link) -2, 2) eq "-1") {$score = -1 * $score;} 
    if (lc($previous_word) ne lc($word )) { #This is the new word
                #print the old one
        if ($previous_word ne "") {
            print_out(\@wordlist, \@scorelist, $previous_word, \@linklist);
        }
        #restore the new values for the new word
        @wordlist = ($word2);
        @scorelist = ($score);
	@linklist = ($link);
        $previous_word = $word;

    }
    else {
        #update the wordlist and scorelist
        push @wordlist, $word2;
        push @scorelist, $score;
	push @linklist , $link;
		
    }

}

#print the last word 
print_out(\@wordlist, \@scorelist, $previous_word, \@linklist);


close IN;


