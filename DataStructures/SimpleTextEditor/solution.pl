#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $S = "";

# keep track of actions
my $undo_stack = [];

my $OPS = {};

# append string
$OPS->{1} = sub {
    my $string = shift;
    push @$undo_stack, "-$string";
    $S .= $string;
};

# remove last k characters
$OPS->{2} = sub {
    my $k = shift;
    $S =~ /(.{0,$k})$/g;
    push @$undo_stack, "+$1";
    $S =~ s/(.{0,$k})$//g;
};

# print kth character
$OPS->{3} = sub {
    my $n = shift;
    print substr($S, $n-1, 1), "\n";
};

# undo
$OPS->{4} = sub {
    pop(@$undo_stack) =~ /^([+-])(.*)$/;
    $OPS->{2}->(length $2) if $1 eq '-';
    $OPS->{1}->($2) if $1 eq '+';

    # option 2 and 1 leave track into the undo stack which should be removed
    pop(@$undo_stack);
};

# we do not need first line in perl
my $first_line = <>;

while (<>){
    /^(\d+)[[:blank:]]*(.+)?/;
    $OPS->{$1}->(defined $2 ? $2 : "");
};
