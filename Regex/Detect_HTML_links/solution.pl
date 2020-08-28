#!/usr/bin/env perl

use warnings;
use strict;
use diagnostics;

my $link_text = qr/<a\b[\w\s[:punct:]]+?\bhref="(?'LINK'[^"]*?)"[\w\s[:punct:]]*?>(?'TAGS'<\/?\w+>(?&TAGS)?)?(?'TEXT'[^<>\/]*)</;

while (<>){
    while ($_ =~ m/$link_text/g) {
        print defined $+{LINK} ? $+{LINK} : '',
              ",",
              defined $+{TEXT} ? $+{TEXT} : '',
              "\n";
    }
}
