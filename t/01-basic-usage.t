use v6.d;

use lib '.';
use lib './lib';

use Text::SubParsers;
use DateTime::Grammar;
use Test;

## 1
my $res1 = "Openheimer's birthday is April 22, 1905 or April 2, 1905, as far as I know.";

ok sub-parser('DateTime').subparse($res1);

## 2
is-deeply
        sub-parser('DateTime').subparse($res1),
        sub-parser(DateTime).subparse($res1);

## 3
is-deeply
        sub-parser('DateTime').subparse($res1),
        sub-parser(&datetime-interpret).subparse($res1);

## 4
my $res4 = 'The dictionary is: [{ "ui" : 3, "io" : 78 }].';

is-deeply
        sub-parser('JSON').subparse($res4),
        $["The dictionary is:", {:io(78), :ui(3)}, "."];

## 5
my $res5 = '[{ "ui" : 3, "io" : 78}, { "GA" : 34, "CA" : 178}]';

is-deeply
        sub-parser('JSON').subparse($res5),
        [{ "ui" => 3, "io" => 78 }, { "GA" => 34, "CA" => 178 }];

## 6
my $res6 = 'The average mass is 55 lbs.';

is-deeply
        sub-parser('Numeric').subparse($res6),
        $["The average mass is", 55, "lbs."];

## 7
is-deeply
        sub-parser({ $_.trim ?? $_.trim.Numeric !! Nil }).subparse($res6),
        $["The average mass is", 55, "lbs."];

## 8
isa-ok sub-parser(Str).subparse($res1), Str:D;

## 9
isa-ok sub-parser('Str').subparse($res1), Str:D;

## 10
my %res10 = 1 => '{ "ui" : 3, "io" : 78}', 2 => '{ "GA" : 34, "CA" : 178}';

is-deeply
        sub-parser('JSON').subparse(%res10),
        %( 1 => { "ui" => 3, "io" => 78 }, 2 => { "GA" => 34, "CA" => 178 });

done-testing;
