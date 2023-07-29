use v6.d;

use lib '.';
use lib './lib';

use Text::SubParsers;
use Test;

## 1
my $res = q:to/END/;
On Dec 23, 1985 around 3/11 by 78+7.3i. Consider { "honda" : 2002, "ford" : 2015, "tesla" : 2018} -- Yes or No?
END

is-deeply
        sub-parser(WhateverCode).subparse($res),
        $["On", DateTime.new(1985,12,23,0,0,0), "around", <3/11>, "by", <78+7.3i>, ". Consider", {:ford(2015), :honda(2002), :tesla(2018)}, "--", Bool::True, "or", Bool::False, "?\n"];

done-testing;
