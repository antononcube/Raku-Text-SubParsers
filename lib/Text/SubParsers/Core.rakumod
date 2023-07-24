use v6.d;

use DateTime::Grammar;
use JSON::Fast;

class Text::SubParsers::Core {
    has $.spec is rw = 'Str';

    multi method new($spec) {
        self.bless(:$spec);
    }

    method subparse($input) {
        return self.parse($input, $!spec, :!exact);
    }

    multi method parse($input, Bool :$exact = True) {
        return self.parse($input, $!spec, :$exact);
    }

    multi method parse(@input, $spec, Bool :$exact = True) {
        return @input.map({ self.parse($_, $spec, :$exact) });
    }

    multi method parse(Str $input, $spec, Bool :$exact = True) {
        my %result = do given $spec {

            when $_.isa(DateTime) ||
                    $_.isa(Date) ||
                    $_ ~~ Str && $_.lc ∈ <DateTime Date>>>.lc {
                self.get-matches($input, &datetime-interpret, :$exact)
            }

            when $_ ~~ Str && $_.lc ∈ <JSON FromJSON from-json>>>.lc {
                self.get-matches($input, &from-json, :$exact);
            }

            when $_.isa(Numeric) ||
                    $_.isa(Num) ||
                    $_ ~~ Str && $_.lc ∈ <Numeric Number>>>.lc {
                self.get-matches($input, { $_.trim ?? $_.trim.Numeric !! Nil }, :$exact);
            }

            when $_.isa(Rational) ||
                    $_.isa(Rat) ||
                    || $_ ~~ Str && $_.lc ∈ <Rat Rational>>>.lc {
                self.get-matches($input, { $_.trim ?? $_.trim.Rat !! Nil }, :$exact);
            }

            when $_.isa(Int) ||
                    $_ ~~ Str && $_.lc ∈ <Int Integer>>>.lc {
                self.get-matches($input, { $_.trim ?? $_.trim.Int !! Nil }, :$exact);
            }

            when $_.isa(UInt) ||
                    $_ ~~ Str && $_.lc ∈ <UInt UnsignedInteger>>>.lc {
                self.get-matches($input, { $_.trim ?? $_.trim.UInt !! Nil }, :$exact);
            }

            when $_.isa(Bool) ||
                    $_ ~~ Str && $_.lc ∈ <Bool Boolean>>>.lc {
                self.get-matches($input, -> $x {
                    given $x.trim {
                        when $_ ~~ /:i t | true | yes | 1 / { True }
                        when $_ ~~ /:i f | false | no | 0 / { False }
                        default { Nil }
                    }
                }, :$exact)
            }

            when $_.isa(Str) ||
                    $_ ~~ Str && $_.lc ∈ <asis Str String>>>.lc {
                %(parsed => $input, error => '')
            }

            when $spec ~~ Callable {
                self.get-matches($input, $spec, :$exact)
            }

            when $_.isa(WhateverCode) || $_.isa(Whatever) {
                %(parsed => $input, error => '')
            }

            default {
                note 'Unknown interpreter specification';
                %(parsed => $input, error => '')
            }
        };

        if %result<error> {
            given $spec {
                when $_ ~~ Str {
                    %result<error> = %result<error>.subst('function', "spec '$spec'")
                }
                when $_ !~~ Callable {
                    %result<error> = %result<error>.subst('function', "spec ({ $spec.^name.Str })")
                }
            }

            note %result<error>;
        }

        return %result<parsed>;
    }

    multi method get-matches(Str $input, &func, Bool :$exact = True) {
        my @ires;
        my @candidates;

        my $pres;
        try {
            $pres = &func($input);
        }

        if $pres.defined && !$! {
            return %(parsed => $pres, error => '');
        }

        if $exact {
            return %(parsed => Nil, error => "Cannot interpret the given input with the given function.");
        }

        my $cind = 0;
        given $input {
            for m:g/ (.+) <?{
                my $p;
                try { $p = &func($0.Str) };
                if !$p.defined || $! { False } else { True }
            }> / -> $match {
                @ires.append($input.substr($cind .. $match.from - 1));
                $cind = $match.to;
                @ires.append(&func(~$match));
                @candidates.append($[$input.substr(0, $match.from), @ires.tail]);
            }
            if $cind < $input.chars {
                @ires.append($input.substr($cind));
            }
        }

        if $cind {
            return %(parsed => @ires, error => '');
        } else {
            return %(parsed => Nil, error => "No interpretations found with the given function for the given input.");
        }
    }
}