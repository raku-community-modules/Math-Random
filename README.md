[![Actions Status](https://github.com/raku-community-modules/Math-Random/actions/workflows/linux.yml/badge.svg)](https://github.com/raku-community-modules/Math-Random/actions) [![Actions Status](https://github.com/raku-community-modules/Math-Random/actions/workflows/macos.yml/badge.svg)](https://github.com/raku-community-modules/Math-Random/actions) [![Actions Status](https://github.com/raku-community-modules/Math-Random/actions/workflows/windows.yml/badge.svg)](https://github.com/raku-community-modules/Math-Random/actions)

NAME
====

Math::Random - Random numbers à la java.util.Random

Background
----------

I was bothered by Rakus's primitive random number handling (only `rand` and `srand`, with no mechanism to have multiple generators in parallel), so, instead of bugging some random people about it, I decided to write a module!

SYNOPSIS
========

```raku
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
```

DESCRIPTION
===========

Math::Random provides a `Math::Random` role, and two classes using this role: `Math::Random::JavaStyle` (which uses the same mechanics as `java.util.Random`), and `Math::Random::MT` (which provides a mersenne twister with a long period of 219937 – 1).

USAGE
=====

The `Math::Random` role requires two methods to be implemented:

```raku
method setSeed(Int:D $seed --> Nil) { ... }
method nxt(Int:D $bits --> Int:D) { ... }
```

Unlike in Java's equivalent, `nxt` is required to accept as large of an input as possible.

METHODS
=======

setSeed(Int $seed)
------------------

Sets the random seed.

nextInt
-------

Returns a random unsigned 32-bit integer.

nextInt(Int $max)
-----------------

Returns a random nonnegative integer less than `$max`.

The upper bound must not exceed `2**32`.

nextLong
--------

Returns a random unsigned 64-bit integer.

nextLong(Int $max)
------------------

Returns a random nonnegative integer less than `$max`.

The upper bound must not exceed `2**64`.

nextBoolean
-----------

Returns `True` or `False`.

nextDouble
----------

Returns a random `Num` in the range [0.0, 1.0).

nextDouble(Num $max)
--------------------

Returns a random `Num` in the range [0.0, `$max`).

nextGaussian
------------

Returns a random value according to the normal distribution.

nxt(Int $bits)
--------------

Returns a random integer with `$bits` bits.

ACKNOWLEDGEMENTS
================

Oracle's documentation on `java.util.Random`, as well as Wikipedia's article on the Mersenne Twister generator.

TODO
====

  * Provide constructors that also set the seed.

  * Ensure thread safety, or create a thread-safe wrapper

  * Provide higher-level methods

  * Tests? They won't be easy to pull off, so if anyone wants to PR...

AUTHORS
=======

  * +merlan #flirora

  * Raku Community

COPYRIGHT AND LICENSE
=====================

Copyright 2015 - 2017 +merlan #flirora

Copyright 2024 Raku Commuity

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

