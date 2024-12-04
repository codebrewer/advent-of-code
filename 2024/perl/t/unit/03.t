#!/usr/bin/env perl

use Test2::V0 -target => 'AdventOfCode::Day03';
use AdventOfCode::Day03 qw(part_1 part_2);
use AdventOfCode::Util 'slurp_input';

is(part_1(slurp_input("./t/share/03/sample-input-1.txt")), 161);
is(part_2(slurp_input("./t/share/03/sample-input-2.txt")), 48);

done_testing;
