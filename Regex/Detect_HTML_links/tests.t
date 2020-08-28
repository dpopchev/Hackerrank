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

my $testname_4 = 'sample input 4';
my $in_4 = <<EOF;
9
<li style="-moz-float-edge: content-box">... that <a href="/wiki/Orval_Overall" title="Orval Overall">Orval Overall</a> <i>(pictured)</i> is the only <b><a href="/wiki/List_of_Major_League_Baseball_pitchers_who_have_struck_out_four_batters_in_one_inning" title="List of Major League Baseball pitchers who have struck out four batters in one inning">Major League Baseball player to strike out four batters in one inning</a></b> in the <a href="/wiki/World_Series" title="World Series">World Series</a>?</li>
<li style="-moz-float-edge: content-box">... that the three cities of the <b><a href="/wiki/West_Triangle_Economic_Zone" title="West Triangle Economic Zone">West Triangle Economic Zone</a></b> contribute 40% of Western China's GDP?</li>
<li style="-moz-float-edge: content-box">... that <i><a href="/wiki/Kismet_(1943_film)" title="Kismet (1943 film)">Kismet</a></i>, directed by <b><a href="/wiki/Gyan_Mukherjee" title="Gyan Mukherjee">Gyan Mukherjee</a></b>, ran at the <a href="/wiki/Roxy_Cinema_(Kolkata)" title="Roxy Cinema (Kolkata)">Roxy, Kolkata</a>, for 3 years and 8 months?</li>
<li style="-moz-float-edge: content-box">... that <a href="/wiki/Vauix_Carter" title="Vauix Carter">Vauix Carter</a> both coached and played for the <b><a href="/wiki/1882_Navy_Midshipmen_football_team" title="1882 Navy Midshipmen football team">1882 Navy Midshipmen football team</a></b>?</li>
<li style="-moz-float-edge: content-box">... that <a href="/wiki/Zhu_Chenhao" title="Zhu Chenhao">Zhu Chenhao</a> was sentenced to <a href="/wiki/Slow_slicing" title="Slow slicing">slow slicing</a> for leading the <b><a href="/wiki/Prince_of_Ning_rebellion" title="Prince of Ning rebellion">Prince of Ning rebellion</a></b> against the <a href="/wiki/Ming_Dynasty" title="Ming Dynasty">Ming Dynasty</a> <a href="/wiki/Zhengde_Emperor" title="Zhengde Emperor">emperor Zhengde</a>?</li>
<li style="-moz-float-edge: content-box">... that <b><a href="/wiki/Mirza_Adeeb" title="Mirza Adeeb">Mirza Adeeb</a></b> was a prominent modern Pakistani <a href="/wiki/Urdu" title="Urdu">Urdu</a> playwright whose later work focuses on social problems and daily life?</li>
<li style="-moz-float-edge: content-box">... that in <i><b><a href="/wiki/La%C3%9Ft_uns_sorgen,_la%C3%9Ft_uns_wachen,_BWV_213" title="Lat uns sorgen, lat uns wachen, BWV 213">Die Wahl des Herkules</a></b></i>, Hercules must choose between the good cop and the bad cop?<br style="clear:both;" />
<div style="text-align: right;" class="noprint"><b><a href="/wiki/Wikipedia:Recent_additions" title="Wikipedia:Recent additions">Archive</a></b>  <b><a href="/wiki/Wikipedia:Your_first_article" title="Wikipedia:Your first article">Start a new article</a></b>  <b><a href="/wiki/Template_talk:Did_you_know" title="Template talk:Did you know">Nominate an article</a></b></div>
</li>
EOF
my $expected_out_4 = <<EOF;
/wiki/Orval_Overall,Orval Overall
/wiki/List_of_Major_League_Baseball_pitchers_who_have_struck_out_four_batters_in_one_inning,Major League Baseball player to strike out four batters in one inning
/wiki/World_Series,World Series
/wiki/West_Triangle_Economic_Zone,West Triangle Economic Zone
/wiki/Kismet_(1943_film),Kismet
/wiki/Gyan_Mukherjee,Gyan Mukherjee
/wiki/Roxy_Cinema_(Kolkata),Roxy, Kolkata
/wiki/Vauix_Carter,Vauix Carter
/wiki/1882_Navy_Midshipmen_football_team,1882 Navy Midshipmen football team
/wiki/Zhu_Chenhao,Zhu Chenhao
/wiki/Slow_slicing,slow slicing
/wiki/Prince_of_Ning_rebellion,Prince of Ning rebellion
/wiki/Ming_Dynasty,Ming Dynasty
/wiki/Zhengde_Emperor,emperor Zhengde
/wiki/Mirza_Adeeb,Mirza Adeeb
/wiki/Urdu,Urdu
/wiki/La%C3%9Ft_uns_sorgen,_la%C3%9Ft_uns_wachen,_BWV_213,Die Wahl des Herkules
/wiki/Wikipedia:Recent_additions,Archive
/wiki/Wikipedia:Your_first_article,Start a new article
/wiki/Template_talk:Did_you_know,Nominate an article
EOF

my $testname_5 = 'sample input 5';
my $in_5 = <<EOF;
7
<center>
<div class="noresize" style="height: 242px; width: 600px; "><map name="ImageMap_1_971996215" id="ImageMap_1_971996215">
<area href="/wiki/File:Pardalotus_punctatus_female_with_nesting_material_-_Risdon_Brook.jpg" shape="rect" coords="3,3,297,238" alt="Female" title="Female" />
<area href="/wiki/File:Pardalotus_punctatus_male_with_nesting_material_-_Risdon_Brook.jpg" shape="rect" coords="302,2,597,238" alt="Male" title="Male" /></map><img alt="Pair of Spotted Pardalotes" src="//upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Female_and_male_Pardalotus_punctatus.jpg/600px-Female_and_male_Pardalotus_punctatus.jpg" width="600" height="242" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Female_and_male_Pardalotus_punctatus.jpg/900px-Female_and_male_Pardalotus_punctatus.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Female_and_male_Pardalotus_punctatus.jpg/1200px-Female_and_male_Pardalotus_punctatus.jpg 2x" usemap="#ImageMap_1_971996215" />
<div style="margin-left: 0px; margin-top: -20px; text-align: left;"><a href="/wiki/File:Female_and_male_Pardalotus_punctatus.jpg" title="About this image"><img alt="About this image" src="//bits.wikimedia.org/static-1.22wmf7/extensions/ImageMap/desc-20.png" style="border: none;" /></a></div>
</div>
</center>
EOF
my $expected_out_5 = <<EOF;
/wiki/File:Female_and_male_Pardalotus_punctatus.jpg,
EOF

my $testname_6 = 'sample input 6';
my $in_6 = <<EOF;
<div style="margin-left: 0px; margin-top: -20px; text-align: left;"><a text='href does not come next' href="/wiki/File:Female_and_male_Pardalotus_punctatus.jpg" title="About this image"><img alt="About this image" src="//bits.wikimedia.org/static-1.22wmf7/extensions/ImageMap/desc-20.png" style="border: none;" /></a></div>
EOF
my $expected_out_6 = <<EOF;
/wiki/File:Female_and_male_Pardalotus_punctatus.jpg,
EOF

script_compiles($script_name);

script_runs([ $script_name ], {stdin => \$in_1}, $testname_1 );
script_stdout_is $expected_out_1, $testname_1;

script_runs([ $script_name ], {stdin => \$in_2}, $testname_2 );
script_stdout_is $expected_out_2, $testname_2;

script_runs([ $script_name ], {stdin => \$in_3}, $testname_3 );
script_stdout_is $expected_out_3, $testname_3;

script_runs([ $script_name ], {stdin => \$in_4}, $testname_4 );
script_stdout_is $expected_out_4, $testname_4;

script_runs([ $script_name ], {stdin => \$in_5}, $testname_5 );
script_stdout_is $expected_out_5, $testname_5;

script_runs([ $script_name ], {stdin => \$in_6}, $testname_6 );
script_stdout_is $expected_out_6, $testname_6;

done_testing;
