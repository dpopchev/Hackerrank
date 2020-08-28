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

my $testname_7 = 'sample input 7';
my $in_7 = <<EOF;
49
<div class="portal" role="navigation" id='p-lang'>
<h3>Languages</h3>
<div class="body">
<ul>
<li class="interwiki-simple"><a href="//simple.wikipedia.org/wiki/" title="" lang="simple" hreflang="simple">Simple English</a></li>
<li class="interwiki-ar"><a href="//ar.wikipedia.org/wiki/" title="" lang="ar" hreflang="ar"></a></li>
<li class="interwiki-id"><a href="//id.wikipedia.org/wiki/" title="" lang="id" hreflang="id">Bahasa Indonesia</a></li>
<li class="interwiki-ms"><a href="//ms.wikipedia.org/wiki/" title="" lang="ms" hreflang="ms">Bahasa Melayu</a></li>
<li class="interwiki-bg"><a href="//bg.wikipedia.org/wiki/" title="" lang="bg" hreflang="bg"></a></li>
<li class="interwiki-ca"><a href="//ca.wikipedia.org/wiki/" title="" lang="ca" hreflang="ca">Catal</a></li>
<li class="interwiki-cs"><a href="//cs.wikipedia.org/wiki/" title="" lang="cs" hreflang="cs">esky</a></li>
<li class="interwiki-da"><a href="//da.wikipedia.org/wiki/" title="" lang="da" hreflang="da"><b>Dansk</b></a></li>
<li class="interwiki-de"><a href="//de.wikipedia.org/wiki/" title="" lang="de" hreflang="de">Deutsch</a></li>
<li class="interwiki-et"><a href="//et.wikipedia.org/wiki/" title="" lang="et" hreflang="et">Eesti</a></li>
<li class="interwiki-el"><a href="//el.wikipedia.org/wiki/" title="" lang="el" hreflang="el"></a></li>
<li class="interwiki-es"><a href="//es.wikipedia.org/wiki/" title="" lang="es" hreflang="es">Espaol</a></li>
<li class="interwiki-eo"><a href="//eo.wikipedia.org/wiki/" title="" lang="eo" hreflang="eo">Esperanto</a></li>
<li class="interwiki-eu"><a href="//eu.wikipedia.org/wiki/" title="" lang="eu" hreflang="eu">Euskara</a></li>
<li class="interwiki-fa"><a href="//fa.wikipedia.org/wiki/" title="" lang="fa" hreflang="fa"></a></li>
<li class="interwiki-fr"><a href="//fr.wikipedia.org/wiki/" title="" lang="fr" hreflang="fr">Franais</a></li>
<li class="interwiki-gl"><a href="//gl.wikipedia.org/wiki/" title="" lang="gl" hreflang="gl">Galego</a></li>
<li class="interwiki-ko"><a href="//ko.wikipedia.org/wiki/" title="" lang="ko" hreflang="ko"></a></li>
<li class="interwiki-he"><a href="//he.wikipedia.org/wiki/" title="" lang="he" hreflang="he"></a></li>
<li class="interwiki-hr"><a href="//hr.wikipedia.org/wiki/" title="" lang="hr" hreflang="hr">Hrvatski</a></li>
<li class="interwiki-it"><a href="//it.wikipedia.org/wiki/" title="" lang="it" hreflang="it">Italiano</a></li>
<li class="interwiki-lt"><a href="//lt.wikipedia.org/wiki/" title="" lang="lt" hreflang="lt">Lietuvi</a></li>
<li class="interwiki-hu"><a href="//hu.wikipedia.org/wiki/" title="" lang="hu" hreflang="hu">Magyar</a></li>
<li class="interwiki-nl"><a href="//nl.wikipedia.org/wiki/" title="" lang="nl" hreflang="nl">Nederlands</a></li>
<li class="interwiki-ja"><a href="//ja.wikipedia.org/wiki/" title="" lang="ja" hreflang="ja"></a></li>
<li class="interwiki-no"><a href="//no.wikipedia.org/wiki/" title="" lang="no" hreflang="no">Norsk bokml</a></li>
<li class="interwiki-nn"><a href="//nn.wikipedia.org/wiki/" title="" lang="nn" hreflang="nn">Norsk nynorsk</a></li>
<li class="interwiki-pl"><a href="//pl.wikipedia.org/wiki/" title="" lang="pl" hreflang="pl">Polski</a></li>
<li class="interwiki-pt"><a href="//pt.wikipedia.org/wiki/" title="" lang="pt" hreflang="pt">Portugus</a></li>
<li class="interwiki-ro"><a href="//ro.wikipedia.org/wiki/" title="" lang="ro" hreflang="ro">Romn</a></li>
<li class="interwiki-ru"><a href="//ru.wikipedia.org/wiki/" title="" lang="ru" hreflang="ru"></a></li>
<li class="interwiki-sk"><a href="//sk.wikipedia.org/wiki/" title="" lang="sk" hreflang="sk">Slovenina</a></li>
<li class="interwiki-sl"><a href="//sl.wikipedia.org/wiki/" title="" lang="sl" hreflang="sl">Slovenina</a></li>
<li class="interwiki-sr"><a href="//sr.wikipedia.org/wiki/" title="" lang="sr" hreflang="sr"> / srpski</a></li>
<li class="interwiki-sh"><a href="//sh.wikipedia.org/wiki/" title="" lang="sh" hreflang="sh">Srpskohrvatski / </a></li>
<li class="interwiki-fi"><a href="//fi.wikipedia.org/wiki/" title="" lang="fi" hreflang="fi">Suomi</a></li>
<li class="interwiki-sv"><a href="//sv.wikipedia.org/wiki/" title="" lang="sv" hreflang="sv">Svenska</a></li>
<li class="interwiki-th"><a href="//th.wikipedia.org/wiki/" title="" lang="th" hreflang="th"></a></li>
<li class="interwiki-vi"><a href="//vi.wikipedia.org/wiki/" title="" lang="vi" hreflang="vi">Ting Vit</a></li>
<li class="interwiki-tr"><a href="//tr.wikipedia.org/wiki/" title="" lang="tr" hreflang="tr">Trke</a></li>
<li class="interwiki-uk"><a href="//uk.wikipedia.org/wiki/" title="" lang="uk" hreflang="uk"></a></li>
<li class="interwiki-zh"><a href="//zh.wikipedia.org/wiki/" title="" lang="zh" hreflang="zh"></a></li>
</ul>
</div>
</div>
EOF
my $expected_out_7 = <<EOF;
//simple.wikipedia.org/wiki/,Simple English
//ar.wikipedia.org/wiki/,
//id.wikipedia.org/wiki/,Bahasa Indonesia
//ms.wikipedia.org/wiki/,Bahasa Melayu
//bg.wikipedia.org/wiki/,
//ca.wikipedia.org/wiki/,Catal
//cs.wikipedia.org/wiki/,esky
//da.wikipedia.org/wiki/,Dansk
//de.wikipedia.org/wiki/,Deutsch
//et.wikipedia.org/wiki/,Eesti
//el.wikipedia.org/wiki/,
//es.wikipedia.org/wiki/,Espaol
//eo.wikipedia.org/wiki/,Esperanto
//eu.wikipedia.org/wiki/,Euskara
//fa.wikipedia.org/wiki/,
//fr.wikipedia.org/wiki/,Franais
//gl.wikipedia.org/wiki/,Galego
//ko.wikipedia.org/wiki/,
//he.wikipedia.org/wiki/,
//hr.wikipedia.org/wiki/,Hrvatski
//it.wikipedia.org/wiki/,Italiano
//lt.wikipedia.org/wiki/,Lietuvi
//hu.wikipedia.org/wiki/,Magyar
//nl.wikipedia.org/wiki/,Nederlands
//ja.wikipedia.org/wiki/,
//no.wikipedia.org/wiki/,Norsk bokml
//nn.wikipedia.org/wiki/,Norsk nynorsk
//pl.wikipedia.org/wiki/,Polski
//pt.wikipedia.org/wiki/,Portugus
//ro.wikipedia.org/wiki/,Romn
//ru.wikipedia.org/wiki/,
//sk.wikipedia.org/wiki/,Slovenina
//sl.wikipedia.org/wiki/,Slovenina
//sr.wikipedia.org/wiki/,/ srpski
//sh.wikipedia.org/wiki/,Srpskohrvatski /
//fi.wikipedia.org/wiki/,Suomi
//sv.wikipedia.org/wiki/,Svenska
//th.wikipedia.org/wiki/,
//vi.wikipedia.org/wiki/,Ting Vit
//tr.wikipedia.org/wiki/,Trke
//uk.wikipedia.org/wiki/,
//zh.wikipedia.org/wiki/,
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

script_runs([ $script_name ], {stdin => \$in_7}, $testname_7 );
script_stdout_is $expected_out_7, $testname_7;

done_testing;
