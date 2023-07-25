use v6.d;

role Text::SubParsers::Functions {

    #-------------------------------------------------------
    method to-bool(Str $x) {
        given $x {
            when $_ ~~ /:i ^ [ true | yes ] $ / { True }
            when $_ ~~ /:i ^ [ false | no ] $ / { False }
            default { Nil }
        }
    }

    #-------------------------------------------------------
    method many-funcs(Str $x is copy,
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


