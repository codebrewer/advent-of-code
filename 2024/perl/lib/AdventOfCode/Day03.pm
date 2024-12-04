package AdventOfCode::Day03;

use strict;
use warnings FATAL => 'all';
use Sub::Exporter -setup => {
    exports => [ qw(part_1 part_2) ],
};

sub begins_with {
    my ($string, $prefix) = @_;

    substr($string, 0, length($prefix)) eq $prefix;
}

sub part_1 {
    my $sum = 0;

    foreach (@_) {
        my @multiplications = $_ =~ /(mul\(\d+,\d+\))/g;

        foreach (@multiplications) {
            my @operands = $_ =~ /(\d+)/g;

            $sum += $operands[0] * $operands[1];
        }
    }

    $sum;
}

sub part_2_using_scanner_lexer {
    my $sum = 0;
    my $multiply_is_active = 1;

    foreach (@_) {
        my $scan_position = 0;

        while ($scan_position < length()) {
            if (begins_with substr($_, $scan_position), "do()") {
                $multiply_is_active = 1;
                $scan_position += length "do()";
            }
            elsif (begins_with substr($_, $scan_position), "don't()") {
                $multiply_is_active = 0;
                $scan_position += length "don't()";
            }
            elsif (substr($_, $scan_position) =~ /^(mul\(\d+,\d+\))/) {
                if ($multiply_is_active == 1) {
                    my @operands = $1 =~ /(\d+)/g;

                    $sum += $operands[0] * $operands[1];
                }

                $scan_position += length $1;
            }
            else {
                $scan_position++;
            }
        }
    }

    $sum;
}

sub part_2 {
    my $sum = 0;
    my $multiply_is_active = 1;

    foreach (@_) {
        my @tokens = $_ =~ /(do\(\)|don\'t\(\)|mul\(\d+,\d+\))/g;

        foreach (@tokens) {
            if ($_ eq "do()") {
                $multiply_is_active = 1;
            }
            elsif ($_ eq "don't()") {
                $multiply_is_active = 0;
            }
            elsif ($multiply_is_active == 1) {
                my @operands = $_ =~ /(\d+)/g;

                $sum += $operands[0] * $operands[1];
            }
        }
    }

    $sum;
}

1;
