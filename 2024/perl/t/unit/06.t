#!/usr/bin/env perl

use Test2::V0 -target => 'AdventOfCode::Day06';
use AdventOfCode::Day06 qw(part_1 part_2);
use AdventOfCode::Util 'slurp_input';

is(scalar @{part_1(slurp_input("./t/share/06/sample-input.txt"))}, 41);
is(part_2(slurp_input("./t/share/06/sample-input.txt")), 6);

done_testing;
