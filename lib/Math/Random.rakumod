unit role Math::Random;

method setSeed(Int $seed --> Nil) { ... }

method nxt(Int $bits --> Int:D) { ... }

multi method nextInt(--> Int:D) { self.nxt(32) }

multi method nextInt(Int $bound --> Int:D) {
    die "$bound must be positive" if $bound <= 0;
    if ($bound +& -$bound) == $bound { # if bound is a power of 2
        return (($bound * self.nxt(31)) +> 31) +& 0xFFFFFFFF;
    }
    my Int $bits;
    my Int $val;
    repeat {
        $bits = self.nxt(31);
        $val = $bits % $bound;
    } while $bits - $val + $bound - 1 < 0;
    $val
}

multi method nextLong(--> Int:D) { self.nxt(64) }

multi method nextLong(Int:D $bound) returns Int {
    die "$bound must be positive" if $bound <= 0;
    if ($bound +& -$bound) == $bound { # if bound is a power of 2
        return (($bound * self.nxt(63)) +> 63) +& 0xFFFF_FFFF_FFFF_FFFF;
    }
    my Int $bits;
    my Int $val;
    repeat {
        $bits = self.nxt(63);
        $val = $bits % $bound;
    } while $bits - $val + $bound - 1 < 0;
    $val
}

method nextBoolean(--> Bool:D){ self.nxt(1) != 0 }

multi method nextDouble(--> Num:D) { self.nxt(53) }

multi method nextDouble(Num:D $max --> Num:D) {
    $max * self.nextDouble;
}

has Num  $!nextNextGaussian;
has Bool $.haveNextGaussian is rw = False;

method nextGaussian(--> Num:D) {
    if ($.haveNextGaussian) {
        $.haveNextGaussian = False;
        $.nextNextGaussian
    }
    else {
        my Num $v1;
        my Num $v2;
        my Num $s;
        repeat {
            $v1 = 2 * self.nextDouble - 1;
            $v2 = 2 * self.nextDouble - 1;
            $s = $v1 * $v1 + $v2 * $v2;
        } while ($s >= 1 || $s == 0);
        my Num $multiplier = sqrt(-2 * log($s) / $s);
        $!nextNextGaussian = $v2 * $multiplier;
        $.haveNextGaussian = True;
        $v1 * $multiplier
    }
}

=begin pod

=head1 NAME

Math::Random - Random numbers à la java.util.Random

=head2 Background

I was bothered by Rakus's primitive random number handling (only
C<rand> and C<srand>, with no mechanism to have multiple generators
in parallel), so, instead of bugging some random people about it,
I decided to write a module!

=head1 SYNOPSIS

=begin code :lang<raku>

use Math::Random::JavaStyle; # uses same mechanics as
                             # java.util.Random
my $j = Math::Random::JavaStyle.new;
$j.setSeed(9001);
say $j.nextInt;
say $j.nextLong;
say $j.nextDouble;
say $j.nextInt(100);
say $j.nextLong(100_000_000_000);
say $j.nextDouble(100);
say $j.nxt(256); # generate a random 256-bit integer
say $j.nextGaussian;

use Math::Random::MT;
my $m64 = Math::Random::MT.mt19937_64;
#...

=end code

=head1 DESCRIPTION

Math::Random provides a C<Math::Random> role, and two classes using this
role: C<Math::Random::JavaStyle> (which uses the same mechanics as
C<java.util.Random>), and C<Math::Random::MT> (which provides a
mersenne twister with a long period of 219937 – 1).

=head1 USAGE

The C<Math::Random> role requires two methods to be implemented:

=begin code :lang<raku>

method setSeed(Int:D $seed --> Nil) { ... }
method nxt(Int:D $bits --> Int:D) { ... }

=end code

Unlike in Java's equivalent, C<nxt> is required to accept as large of an input
as possible.

=head1 METHODS

=head2 setSeed(Int $seed)

Sets the random seed.

=head2 nextInt

Returns a random unsigned 32-bit integer.

=head2 nextInt(Int $max)

Returns a random nonnegative integer less than `$max`.

The upper bound must not exceed `2**32`.

=head2 nextLong

Returns a random unsigned 64-bit integer.

=head2 nextLong(Int $max)

Returns a random nonnegative integer less than `$max`.

The upper bound must not exceed `2**64`.

=head2 nextBoolean

Returns `True` or `False`.

=head2 nextDouble

Returns a random `Num` in the range [0.0, 1.0).

=head2 nextDouble(Num $max)

Returns a random `Num` in the range [0.0, `$max`).

=head2 nextGaussian

Returns a random value according to the normal distribution.

=head2 nxt(Int $bits)

Returns a random integer with `$bits` bits.

=head1 ACKNOWLEDGEMENTS

Oracle's documentation on C<java.util.Random>, as well as Wikipedia's article
on the Mersenne Twister generator.

=head1 TODO

=item Provide constructors that also set the seed.
=item Ensure thread safety, or create a thread-safe wrapper
=item Provide higher-level methods
=item Tests? They won't be easy to pull off, so if anyone wants to PR...

=head1 AUTHORS

=item Tae Lim Koo
=item Raku Community

=head1 COPYRIGHT AND LICENSE

Copyright 2015 - 2017 Tae Lim Koo

Copyright 2024 Raku Commuity

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
