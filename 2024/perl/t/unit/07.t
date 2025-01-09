#!/usr/bin/env perl

use Test2::V0 -target => 'AdventOfCode::Day07';
use AdventOfCode::Day07 qw(part_1 part_2);
use AdventOfCode::Util 'slurp_input';

is(part_1(slurp_input("./t/share/07/sample-input.txt")), 3749);
is(part_2(slurp_input("./t/share/07/sample-input.txt")), 11387);

done_testing;
