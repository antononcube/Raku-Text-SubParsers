use v6.d;

use Text::SubParsers::Core;

unit module Text::SubParsers;

#===========================================================
#| Get a sub-parser.
#| C<spec> -- Sub-parser specification.
#| C<exact> -- Should the parsing with the method C<process> be exact or not?
our proto sub sub-parser(|) is export {*}

multi sub sub-parser($spec, Bool $exact = False, Bool :$drop = False) {
    return sub-parser(:$spec, :$exact, :$drop);
}

multi sub sub-parser(:$spec, Bool :$exact = False, Bool :$drop = False) {
    return do given $spec {
        when Text::SubParsers::Core { $spec }
        when Str { Text::SubParsers::Core.new(:$spec, :$exact, :$drop) }
        default { Text::SubParsers::Core.new(:$spec, :$exact, :$drop) }
    }
}

#===========================================================
#| Get exact parser
our proto sub exact-parser(|) is export {*}

multi sub exact-parser($spec) {
    return sub-parser(:$spec, :exact, :!drop);
}

multi sub exact-parser(:$spec) {
    return sub-parser(:$spec, :exact, :!drop);
}
