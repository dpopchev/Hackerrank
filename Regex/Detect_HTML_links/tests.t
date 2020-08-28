#!/usr/bin/env perl

use warnings;
use strict;
use diagnostics;

use Data::Dumper;

use Test2::V0;
use Test::Script;

my $script_name = 'solution.pl';

my $testname_1 = 'sample input 1';
my $in_1 = <<EOF;
2
<p><a href="http://www.quackit.com/html/tutorial/html_links.cfm">Example Link</a></p>
<div class="more-info"><a href="http://www.quackit.com/html/examples/html_links_examples.cfm">More Link Examples...</a></div>
EOF
my $expected_out_1 = <<EOF;
http://www.quackit.com/html/tutorial/html_links.cfm,Example Link
http://www.quackit.com/html/examples/html_links_examples.cfm,More Link Examples...
EOF

my $testname_2 = 'sample input 2';
my $in_2 = <<EOF;
13
<div class="portal" role="navigation" id='p-navigation'>
<h3>Navigation</h3>
<div class="body">
<ul>
 <li id="n-mainpage-description"><a href="/wiki/Main_Page" title="Visit the main page [z]" accesskey="z">Main page</a></li>
 <li id="n-contents"><a href="/wiki/Portal:Contents" title="Guides to browsing Wikipedia">Contents</a></li>
 <li id="n-featuredcontent"><a href="/wiki/Portal:Featured_content" title="Featured content  the best of Wikipedia">Featured content</a></li>
<li id="n-currentevents"><a href="/wiki/Portal:Current_events" title="Find background information on current events">Current events</a></li>
<li id="n-randompage"><a href="/wiki/Special:Random" title="Load a random article [x]" accesskey="x">Random article</a></li>
<li id="n-sitesupport"><a href="//donate.wikimedia.org/wiki/Special:FundraiserRedirector?utm_source=donate&utm_medium=sidebar&utm_campaign=C13_en.wikipedia.org&uselang=en" title="Support us">Donate to Wikipedia</a></li>
</ul>
</div>
</div>
EOF
my $expected_out_2 = <<EOF;
/wiki/Main_Page,Main page
/wiki/Portal:Contents,Contents
/wiki/Portal:Featured_content,Featured content
/wiki/Portal:Current_events,Current events
/wiki/Special:Random,Random article
//donate.wikimedia.org/wiki/Special:FundraiserRedirector?utm_source=donate&utm_medium=sidebar&utm_campaign=C13_en.wikipedia.org&uselang=en,Donate to Wikipedia
EOF

my $testname_3 = 'sample input 3';
my $in_3 = <<EOF;
2
<p><a href="">Example Link</a></p>
<div class="more-info"><a href="http://www.quackit.com/html/examples/html_links_examples.cfm"></a></div>
EOF
my $expected_out_3 = <<EOF;
,Example Link
http://www.quackit.com/html/examples/html_links_examples.cfm,
EOF

script_compiles($script_name);

script_runs([ $script_name ], {stdin => \$in_1}, $testname_1 );
script_stdout_is $expected_out_1, $testname_1;

script_runs([ $script_name ], {stdin => \$in_2}, $testname_2 );
script_stdout_is $expected_out_2, $testname_2;

script_runs([ $script_name ], {stdin => \$in_3}, $testname_3 );
script_stdout_is $expected_out_3, $testname_3;

done_testing;
