#!/usr/bin/env perl

use Test2::V0 -target => 'AdventOfCode::Day05';
use AdventOfCode::Day05 qw(part_1 part_2);
use AdventOfCode::Util 'slurp_input';

is(part_1(slurp_input("./t/share/05/sample-input.txt")), 143);
is(part_2(slurp_input("./t/share/05/sample-input.txt")), 123);

done_testing;
