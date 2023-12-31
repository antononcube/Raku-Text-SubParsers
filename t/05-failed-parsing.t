use v6.d;

use lib '.';
use lib './lib';

use Text::SubParsers;
use Test;

## 1
my $res = q:to/END/;
Some list [1, 2, 4].
END

## 1
fails-like { sub-parser(DateTime).subparse($res) }, X::AdHoc;

## 2
my $res2 = sub-parser(DateTime).subparse($res);
isa-ok $res2.exception.payload, Hash;

## 3
is-deeply $res2.exception.payload.keys.sort, <input parsed error>.sort;

## 4
fails-like { exact-parser(DateTime).parse($res) }, X::AdHoc;

## 5
my $res5 = exact-parser(DateTime).subparse($res);
isa-ok $res5.exception.payload, Hash;

## 6
is-deeply $res5.exception.payload.keys.sort, <input parsed error>.sort;

done-testing;
