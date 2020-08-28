#!/usr/bin/env perl

use warnings;
use strict;
use diagnostics;

my $link_text = qr/<a\b[\w\s[:punct:]]+?\bhref="(?'LINK'[^"]*?)"[\w\s[:punct:]]*?>(?'TAGS'<\/?[\w\s[:punct:]]+?>(?&TAGS)?)?(?'TEXT'[\w\s[:punct:]]*?)(?=<\/\w+>)/;

while (<>){
    while ($_ =~ m/$link_text/g) {
        print defined $+{LINK} ? $+{LINK} =~ s/^\s+|\s+$//r : '',
              ",",
              defined $+{TEXT} ? $+{TEXT} =~ s/^\s+|\s+$//r : '',
              "\n";
    }
}
