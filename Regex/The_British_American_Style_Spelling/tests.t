#!/usr/bin/env perl

use warnings;
use strict;
use diagnostics;

use Data::Dumper;

use Test::More 'no_plan';
use Test::Script;

use File::Spec::Functions;

my $script = 'solution.pl';

# the test case files and expected results have common name
my $tc_folder      = "testcases";
my $file_formatter = "TC%d";
my $testcase_files = [];
my $results_files  = [];

# fill available test cases and expected results
my $testcases_count = 1;
for (1..$testcases_count){
    push @$testcase_files , sprintf catfile($tc_folder, $file_formatter), $_;
    push @$results_files  , $testcase_files->[-1].'_expect';
}

# test if script compiles
script_compiles($script);

# iterate through test cases and respected results
for my $tc_num (0..scalar @$testcase_files - 1){

    open my $fh_tc     , '<' , $testcase_files->[$tc_num] or die $!;
    open my $fh_expect , '<' , $results_files->[$tc_num]  or die $!;

    read $fh_tc     , my $tc_content , -s $fh_tc;
    read $fh_expect , my $tc_expect  , -s $fh_expect;

    close $fh_tc;
    close $fh_expect;

    # redirect script stdin and stdout to variables
    my $tc_got;
    my $script_run_opts = {
        stdin  =>  \$tc_content,
        stdout =>  \$tc_got
    };

    # execute test with test case input
    # and save the output into $tc_got
    script_runs( [ $script ],
                 $script_run_opts,
                 sprintf($file_formatter.' exec', $tc_num+1)
                 );

    # compare script and expected outptu
    is_deeply( [split '\n', $tc_got],
               [split '\n', $tc_expect],
               sprintf($file_formatter.' compare', $tc_num+1)
               );
}
