use v6.d;

use Text::SubParsers::Core;

unit module Text::SubParsers;

#===========================================================
our proto sub get-sub-parser(|) is export {*}

multi sub get-sub-parser($spec, Bool $exact = False) {
    return get-sub-parser(:$spec, :$exact);
}

multi sub get-sub-parser(:$spec, Bool :$exact = False) {
    return do given $spec {
        when Text::SubParsers::Core { $spec }
        when Str { Text::SubParsers::Core.new(:$spec, :$exact) }
        default { Text::SubParsers::Core.new(:$spec, :$exact) }
    }
}

#===========================================================
our proto sub get-parser(|) is export {*}

multi sub get-parser($spec) {
    return get-sub-parser(:$spec, :exact);
}

multi sub get-parser(:$spec) {
    return get-sub-parser(:$spec, :exact);
}
