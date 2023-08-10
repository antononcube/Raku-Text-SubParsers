use v6.d;

use lib '.';
use lib './lib';

use Text::SubParsers;
use DateTime::Grammar;
use Test;

## 1
my $res1 = "Openheimer's birthday is April 22, 1905 or April 2, 1905, as far as I know.";

ok Text::SubParsers::Core.new('DateTime').subparse($res1);

## 2
is-deeply
        Text::SubParsers::Core.new(spec => 'DateTime', :!exact).subparse($res1),
        Text::SubParsers::Core.new(spec => DateTime, :!exact).subparse($res1);

## 3
is-deeply
        Text::SubParsers::Core.new('DateTime').subparse($res1),
        Text::SubParsers::Core.new(&datetime-interpret).subparse($res1);

## 4
my $res4 = 'The dictionary is: [{ "ui" : 3, "io" : 78 }].';

is-deeply
        Text::SubParsers::Core.new('JSON').subparse($res4),
        $["The dictionary is:", { :io(78), :ui(3) }, "."];

## 5
my $res5 = '[{ "ui" : 3, "io" : 78}, { "GA" : 34, "CA" : 178}]';

is-deeply
        Text::SubParsers::Core.new('JSON').subparse($res5),
        [{ "ui" => 3, "io" => 78 }, { "GA" => 34, "CA" => 178 }];

## 6
my $res6 = 'The average mass is 55 lbs.';

is-deeply
        Text::SubParsers::Core.new(Numeric).subparse($res6),
        $["The average mass is", 55, "lbs."];

## 7
is-deeply
        Text::SubParsers::Core.new({ $_.trim ?? $_.trim.Numeric !! Nil }).subparse($res6),
        $["The average mass is", 55, "lbs."];

## 8
my $res8 = 'The average anti-mass is -5.4E-12 kg.';

is-deeply
        Text::SubParsers::Core.new(Numeric).subparse($res8),
        $["The average anti-mass is", -5.4e-12, "kg."];

## 9
my $res9 = 'The rocket speed was 24,133 m/s.';

is-deeply
        Text::SubParsers::Core.new('GeneralNumber').subparse($res9),
        $["The rocket speed was", 24_133, "m/s."];

## 10
is
        Text::SubParsers::Core.new(spec => DateTime, :!exact, :drop).subparse($res1).elems,
        2,
        'Two dates recognized into a two element list if :drop';

## 11
is
        Text::SubParsers::Core.new(spec => DateTime, :!exact, :!drop).subparse($res1).elems,
        5,
        'Two dates recognized into a five element list if :!drop';

## 12
is-deeply
        Text::SubParsers::Core.new(spec => 'DateTime', :!exact, :drop).subparse($res1),
        Text::SubParsers::Core.new(spec => DateTime, :!exact, :drop).subparse($res1);

done-testing;
