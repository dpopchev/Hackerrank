#!/usr/bin/env perl

use warnings;
use strict;
use diagnostics;

my $link_text = qr/href="(?'LINK'[^"]*)"[\w\s[:punct:]]*?>(?'TAGS'<\/?\w+>(?&TAGS)?)?(?'TEXT'[^<>\/]*)</;

while (<>){
    if ($_ =~ m/$link_text/) {
        print defined $+{LINK} ? $+{LINK} : '',
              ",",
              defined $+{TEXT} ? $+{TEXT} : '',
              "\n";
    }
}
