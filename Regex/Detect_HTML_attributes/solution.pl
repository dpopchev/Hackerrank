#!/usr/bin/env perl

use warnings;
use strict;
use diagnostics;

my $link_text = qr/# match the start of a anchor tag and consume all
                   # options which are not related to href
                   <a\b[\w\s[:punct:]]+?
                   # match the link enclosed into double qutes
                   # of a href option
                   \bhref="(?'LINK'[^"]*?)"[\w\s[:punct:]]*?>
                   # match the rest opening or single tags
                   (?'TAGS'<\/?[\w\s[:punct:]]+?>(?&TAGS)?)?
                   # until the text itself is reached
                   (?'TEXT'[\w\s[:punct:]]*?)
                   # the text is evrything until a closing tag is met
                   (?=<\/\w+>)/x;

# read from STDIN
while (<>){
    # go through all matches in the link
    while ($_ =~ m/$link_text/g) {
        # print the captured groups in desired output format
        # check if the groups have captured anything, as they may be empty
        # if they did -- trim leading and trailing spaces
        print defined $+{LINK} ? $+{LINK} =~ s/^\s+|\s+$//r : '',
              ",",
              defined $+{TEXT} ? $+{TEXT} =~ s/^\s+|\s+$//r : '',
              "\n";
    }
}
<(?'TAG'\w+)\s*(?'ATTR'\w+="[\w[:punct:]\s]+?"\s*(?&ATTR)?)?\/?>