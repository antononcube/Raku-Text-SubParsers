use v6.d;

use DateTime::Grammar;
use JSON::Fast;
use Text::SubParsers::Functions;

class Text::SubParsers::Core
        does Text::SubParsers::Functions {
    has $.spec is rw = 'Str';
    has Bool $.exact is rw = False;

    #-------------------------------------------------------
    multi method new($spec) {
        self.bless(:$spec, :!exact);
    }

    multi method new($spec, Bool $exact) {
        self.bless(:$spec, :$exact);
    }

    #-------------------------------------------------------
    method process($input) {
        return self.parse($input, $!spec, :$!exact);
    }

    #-------------------------------------------------------
    method subparse($input) {
        return self.parse($input, $!spec, :!exact);
    }

    #-------------------------------------------------------
    multi method parse($input, Bool :$exact = True) {
        return self.parse($input, $!spec, :$exact);
    }

    multi method parse(@input, $spec, Bool :$exact = True) {
        return @input.map({ self.parse($_, $spec, :$exact) });
    }

    multi method parse(Str $input, $spec, Bool :$exact = True) {
        my %result = do given $spec {

            when $_ ~~ DateTime:U ||
                    $_ ~~ Date:U ||
                    $_ ~~ Str:D && $_.lc ∈ <DateTime Date>>>.lc {
                self.get-matches($input.trim, &datetime-interpret, :$exact)
            }

            when $_ ~~ Str:D && $_.lc ∈ <JSON FromJSON from-json>>>.lc {
                self.get-matches($input.trim, &from-json, :$exact);
            }

            when $_ ~~ Numeric:U ||
                    $_ ~~ Num:U ||
                    $_ ~~ Str:D && $_.lc ∈ <Numeric Number>>>.lc {
                self.get-matches($input, { $_.trim ?? $_.trim.Numeric !! Nil }, :$exact);
            }

            when $_ ~~ Rational:U ||
                    $_ ~~ Rat:U ||
                    $_ ~~ Str:D && $_.lc ∈ <Rat Rational>>>.lc {
                self.get-matches($input, { $_.trim ?? $_.trim.Rat !! Nil }, :$exact);
            }

            when $_ ~~ Int:U ||
                    $_ ~~ Str:D && $_.lc ∈ <Int Integer>>>.lc {
                self.get-matches($input, { $_.trim ?? $_.trim.Int !! Nil }, :$exact);
            }

            when $_ ~~ UInt:U ||
                    $_ ~~ Str:D && $_.lc ∈ <UInt UnsignedInteger>>>.lc {
                self.get-matches($input, { $_.trim ?? $_.trim.UInt !! Nil }, :$exact);
            }

            when $_ ~~ Complex:U ||
                    $_ ~~ Str:D && $_.lc ∈ <complex> {
                self.get-matches($input, { $_.trim ?? $_.trim.Complex !! Nil }, :$exact);
            }

            when $_ ~~ Bool:U ||
                    $_ ~~ Str:D && $_.lc ∈ <Bool Boolean>>>.lc {
                self.get-matches($input, { self.to-bool($_) }, :$exact)
            }

            when $_ ~~ Str:U ||
                    $_ ~~ Str:D && $_.lc ∈ <asis Str String>>>.lc {
                %(parsed => $input, error => '')
            }

            when $_.isa(WhateverCode) || $_.isa(Whatever) {
                my %res =
                        self.get-matches(
                                $input,
                                { self.many-funcs($_, [&datetime-interpret,
                                                       &from-json,
                                                       { $_.Numeric },
                                                       { self.to-bool($_) }])
                                },
                                :$exact);

                with %res<parsed> {
                    %res
                } else {
                    %(parsed => $input, error => '')
                }
            }

            when $spec ~~ Callable {
                self.get-matches($input, $spec, :$exact)
            }

            default {
                note 'Unknown interpreter specification.';
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

    #-------------------------------------------------------
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
                if $cind < $match.from - 1 {
                    @ires.append($input.substr($cind .. $match.from - 1));
                }
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