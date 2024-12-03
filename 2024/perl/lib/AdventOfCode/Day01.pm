package AdventOfCode::Day01;

use strict;
use warnings FATAL => 'all';
use Sub::Exporter -setup => {
    exports => [ qw(part_1 part_2) ],
};

sub part_1 {
    my $distance;
    my @left = ();
    my @right = ();

    foreach (@_) {
        $_ =~ /^(\d+)\s+(\d+)$/;
        push @left, $1;
        push @right, $2;
    }

    my @sorted_left = sort { $a <=> $b } @left;
    my @sorted_right = sort { $a <=> $b } @right;

    for my $index (0 .. @sorted_left - 1) {
        $distance += abs $sorted_left[$index] - $sorted_right[$index];
    }

    $distance;
}

sub part_2 {
    my $similarity_scores_total;
    my %similarity_scores = ();
    my @left = ();
    my @right = ();

    foreach (@_) {
        $_ =~ /^(\d+)\s+(\d+)$/;
        push @left, $1;
        push @right, $2;
    }

    foreach (@right) {
        if (defined $similarity_scores{$_}) {
            $similarity_scores{$_}++;
        } else {
            $similarity_scores{$_} = 1;
        }
    }

    foreach (@left) {
        if (defined $similarity_scores{$_}) {
            $similarity_scores_total += $_ * $similarity_scores{$_};
        }
    }

    $similarity_scores_total;
}

1;
