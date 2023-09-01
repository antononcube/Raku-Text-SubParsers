use v6.d;

use lib '.';
use lib './lib';

use Text::SubParsers;
use Test;

## 1
ok sub-parser([{ .Int }, { .Numeric }]).process('123');

## 2
is exact-parser([{ .Int }, { .Numeric }]).process('123'), 123;

## 3
is exact-parser([{ .UInt }, { .Int }, { .Numeric }]).process('-123'), -123;

## 4
is exact-parser([{ if $_ ~~ / ^ ['+'|'-']? \d+ $ / { $_.Int } else { Nil } }, { .Numeric }]).process('123.032'), 123.032;

## 5
is exact-parser([{ if $_ ~~ / ^ ['+'|'-']? \d+ $ / { $_.Int } else { Nil } }, { .Numeric }]).process('-123.032'), -123.032;

## 6
is exact-parser([{ .Int }, { .Numeric }, {.Str}]).process('red454'), 'red454';

## 7
my %inp7 = 1 => 'er3rd', max-tokens => '454', top-n => '0.32', temperature => '0.67';
my %res7 = 1 => 'er3rd', max-tokens => 454, top-n => 0.32, temperature => 0.67;
is-deeply
        exact-parser([{ .Numeric }, {.Str}]).process(%inp7),
        %res7;

done-testing;
