use v6.d;

use Text::SubParsers::Core;

unit module Text::SubParsers;

#===========================================================
proto sub get-subparser($spec) is export {*}

multi sub get-subparser($spec, Bool :$exact = False) {
    return do given $spec {
        when Text::SubParsers::Core { $spec }
        when Str { Text::SubParsers::Core.new(:$spec, :$exact) }
        default { Text::SubParsers::Core.new(:$spec, :$exact) }
    }
}

#===========================================================
sub get-parser($spec) is export {
    return get-subparser($spec, :exact);
}
