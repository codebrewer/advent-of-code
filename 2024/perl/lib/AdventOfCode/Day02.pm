package AdventOfCode::Day02;

use strict;
use warnings FATAL => 'all';
use Sub::Exporter -setup => {
    exports => [ qw(part_1 part_2) ],
};

sub is_report_safe {
    my $report_ref = $_[0];
    my $monotony = 0;

    for my $level_index (0 .. @$report_ref - 2) {
        my $delta = @$report_ref[$level_index] - @$report_ref[$level_index + 1];
        next if $delta == 0 || abs $delta > 3;
        $monotony += $delta < 0 ? -1 : 1;
    }

    abs $monotony == @$report_ref - 1;
}

sub permute_report_levels {
    my $report_ref = $_[0];
    my @permuted_report_levels = ([@$report_ref]);

    for my $level_index (0 .. @$report_ref - 1) {
        my @report_copy = @$report_ref;

        splice @report_copy, $level_index, 1;
        push @permuted_report_levels, [@report_copy];
    }

    @permuted_report_levels;
}

sub part_1 {
    my $safe_level_count = 0;

    foreach (@_) {
        my @levels = split /\s+/;

        $safe_level_count++ if (is_report_safe \@levels);
    }

    $safe_level_count;
}

sub part_2 {
    my $safe_level_count;

    foreach (@_) {
        my @levels = split /\s+/;
        my @permuted_levels = permute_report_levels(\@levels);

        foreach (@permuted_levels) {
            if (is_report_safe \@$_) {
                $safe_level_count++;
                last;
            }
        }
    }

    $safe_level_count;
}

1;
