#!/usr/bin/env perl

use Test2::V0 -target => 'AdventOfCode::Day02';
use AdventOfCode::Day02 qw(part_1 part_2);
use AdventOfCode::Util 'slurp_input';

is(part_1(slurp_input("./t/share/02/sample-input.txt")), 2);
is(part_2(slurp_input("./t/share/02/sample-input.txt")), 4);

done_testing;
