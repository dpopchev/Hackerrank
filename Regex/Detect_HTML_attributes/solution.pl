#!/usr/bin/env perl

use warnings;
use strict;
use diagnostics;

use Data::Dumper;

# reg exp matches the tag and all its attributes
my $tag_attr = qr/ <(?'TAG'\w+)\s*
                   (?'ATTR'\w+="[\w[:punct:]\s]+?"\s*(?&ATTR)?)?\/?
                   >/x;

# attribute name
my $attr_name = qr/(?'ATTR_NAME'\w+)=/x;

# fill here the resulting matches
# the tag match is used as a key, the attributes are filled into list
my $r = {};

# read from STDIN
while (<>){

    # go through all matches
    while ($_ =~ m/$tag_attr/g) {

        # capture group name is destroyed as soon as new match is done
        my $_tag  = $+{TAG};
        my $_attr = $+{ATTR};

        $r->{$_tag} = [] unless exists $r->{$_tag};

        # if any attributes found fill them into the tag list
        push @{$r->{$_tag}}, $+{ATTR_NAME} while ( defined $_attr
                                                   and $_attr =~ m/$attr_name/g);
    }
}

# print the results in lexicographical order
for my $k (sort keys %$r){

    print "$k:";

    # dummy hash to help remove duplicate attributes of a tag
    my $seen = {};
    print join ',', sort(grep { ! $seen->{$_} ++ } @{$r->{$k}});

    print "\n";
}
