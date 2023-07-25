use v6.d;

role Text::SubParsers::Functions {

    #-------------------------------------------------------
    method to-bool(Str $x) {
        given $x.trim {
            when $_ ~~ /:i ^ \h* [t | true | yes | 1] \h* $ / { True }
            when $_ ~~ /:i ^ \h* [f | false | no | 0] \h* $ / { False }
            default { Nil }
        }
    }

    #-------------------------------------------------------
    method many-func(Str $x is copy,
                     @funcs where @funcs.all ~~ Callable) {
        my $res;

        $x = $x.trim;

        if !$x { return Nil }

        for @funcs -> &f {
            try {
                $res = &f($x);
            }

            with $res && !$! { return $res; }
        }

        return Nil;
    }
}


