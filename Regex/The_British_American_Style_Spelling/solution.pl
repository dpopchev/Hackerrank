#!/usr/bin/env perl

use warnings;
use strict;
use diagnostics;

use Data::Dumper;

# lets try to match searched words,
# may fail if text also contains single word on a line
my $word_tc = qr/(?'W_TC'^[a-zA-Z]+)(ze|se)$/;

# slurp test case text
my $text;

while (my $input_line = <>){
    if ($input_line =~ /$word_tc/){
        my $word_two_forms = qr/\b$+{W_TC}(?:ze|se)\b/;

        my @matches = $text =~ /$word_two_forms/gi;

        print scalar @matches,"\n";
    }else {
        $text .= $input_line;
    }
}
