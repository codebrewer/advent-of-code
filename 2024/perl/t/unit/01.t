#!/usr/bin/env perl

use Test2::V0 -target => 'AdventOfCode::Day01';
use AdventOfCode::Day01 qw(part_1 part_2);
use AdventOfCode::Util 'slurp_input';

is(part_1(slurp_input("./t/share/01/sample-input.txt")), 11);
is(part_2(slurp_input("./t/share/01/sample-input.txt")), 31);

done_testing;
