use v6.d;

use lib '.';
use lib './lib';

use Text::SubParsers;
use DateTime::Grammar;
use Test;

## 1
my $input1 = "Openheimer's birthday is April 22, 1905 or April 2, 1905, as far as I know.";

ok Text::SubParsers::Core.new('DateTime').subparse($input1);

## 2
is-deeply
        Text::SubParsers::Core.new(spec => 'DateTime', :!exact).subparse($input1),
        Text::SubParsers::Core.new(spec => DateTime, :!exact).subparse($input1);

## 3
is-deeply
        Text::SubParsers::Core.new('DateTime').subparse($input1),
        Text::SubParsers::Core.new(&datetime-interpret).subparse($input1);

## 4
my $input4 = 'The dictionary is: [{ "ui" : 3, "io" : 78 }].';

is-deeply
        Text::SubParsers::Core.new('JSON').subparse($input4),
        $["The dictionary is:", { :io(78), :ui(3) }, "."];

## 5
my $input5 = '[{ "ui" : 3, "io" : 78}, { "GA" : 34, "CA" : 178}]';

is-deeply
        Text::SubParsers::Core.new('JSON').subparse($input5),
        [{ "ui" => 3, "io" => 78 }, { "GA" => 34, "CA" => 178 }];

## 6
my $input6 = 'The average mass is 55 lbs.';

is-deeply
        Text::SubParsers::Core.new(Numeric).subparse($input6),
        $["The average mass is", 55, "lbs."];

## 7
is-deeply
        Text::SubParsers::Core.new({ $_.trim ?? $_.trim.Numeric !! Nil }).subparse($input6),
        $["The average mass is", 55, "lbs."];

## 8
my $input8 = 'The average anti-mass is -5.4E-12 kg.';

is-deeply
        Text::SubParsers::Core.new(Numeric).subparse($input8),
        $["The average anti-mass is", -5.4e-12, "kg."];

## 9
my $input9 = 'The rocket speed was 24,133 m/s.';

is-deeply
        Text::SubParsers::Core.new('GeneralNumber').subparse($input9),
        $["The rocket speed was", 24_133, "m/s."];

## 10
is
        Text::SubParsers::Core.new(spec => DateTime, :!exact, :drop).subparse($input1).elems,
        2,
        'Two dates recognized into a two element list if :drop';

## 11
is
        Text::SubParsers::Core.new(spec => DateTime, :!exact, :!drop).subparse($input1).elems,
        5,
        'Two dates recognized into a five element list if :!drop';

## 12
is-deeply
        Text::SubParsers::Core.new(spec => 'DateTime', :!exact, :drop).subparse($input1),
        Text::SubParsers::Core.new(spec => DateTime, :!exact, :drop).subparse($input1);

## 13
my $input13 = "As of July 2020, the population of Niger is estimated to be 22,542,959 people.";
my $res13 = $[DateTime.new(2020,7,1,0,0,0), 22_542_959];

is-deeply
        Text::SubParsers::Core.new(spec => Whatever, :!exact, :drop).subparse($input13),
        $res13;


done-testing;
