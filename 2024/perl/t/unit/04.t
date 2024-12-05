#!/usr/bin/env perl

use Test2::V0 -target => 'AdventOfCode::Day04';
use AdventOfCode::Day04 qw(part_1 part_2);
use AdventOfCode::Util 'slurp_input';

is(part_1(slurp_input("./t/share/04/sample-input.txt")), 18);
is(part_2(slurp_input("./t/share/04/sample-input.txt")), 9);

done_testing;
