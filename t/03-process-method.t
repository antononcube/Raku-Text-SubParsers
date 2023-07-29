use v6.d;

use lib '.';
use lib './lib';

use Text::SubParsers;
use DateTime::Grammar;
use Test;

## 1
my $res1 = "Openheimer's birthday is April 22, 1905 or April 2, 1905, as far as I know.";

nok exact-parser('DateTime').process($res1);

## 2
ok sub-parser('DateTime').process($res1);

## 3
my $res2 = 'April 22, 1905';
isa-ok sub-parser('DateTime').process($res2), DateTime;

## 3
isa-ok exact-parser('DateTime').process($res2), DateTime;

done-testing;
