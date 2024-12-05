package AdventOfCode::Day04;

use strict;
use warnings FATAL => 'all';
use Sub::Exporter -setup => {
    exports => [ qw(part_1 part_2) ],
};
use constant DIRECTIONS => {
    north      => [ 0, -1 ],
    north_east => [ 1, -1 ],
    east       => [ 1, 0 ],
    south_east => [ 1, 1 ],
    south      => [ 0, 1 ],
    south_west => [ -1, 1 ],
    west       => [ -1, -0 ],
    north_west => [ -1, -1 ]
};
use constant XMAS => 'XMAS';

sub word_starting_at {
    my ($matrix_ref, $x_index, $y_index, $x_index_max, $y_index_max, $word_length, $dx, $dy) = @_;
    my $word = "";

    while (length $word < $word_length &&
        $x_index >= 0 &&
        $x_index <= $x_index_max &&
        $y_index >= 0 &&
        $y_index <= $y_index_max) {

        $word .= $matrix_ref->[$y_index]->[$x_index];
        $x_index += $dx;
        $y_index += $dy;
    }

    $word;
}

sub three_letter_words_crossing_at {
    my ($matrix_ref, $x, $y) = @_;
    my @words;

    push @words, $matrix_ref->[$y - 1]->[$x - 1] . $matrix_ref->[$y]->[$x] . $matrix_ref->[$y + 1]->[$x + 1];
    push @words, $matrix_ref->[$y + 1]->[$x - 1] . $matrix_ref->[$y]->[$x] . $matrix_ref->[$y - 1]->[$x + 1];

    @words;
}

sub part_1 {
    my $word_count = 0;
    my $x_index = 0;
    my $x_index_max;
    my $y_index = 0;
    my $y_index_max = @_ - 1;
    my @matrix;
    my @row;

    foreach (@_) {
        @row = split //;

        for $y_index (0 .. @row - 1) {
            $matrix[$x_index][$y_index] = $row[$y_index];
        }

        $x_index++;
    }

    $x_index_max = $x_index - 1;

    foreach $x_index (0 .. $x_index_max) {
        foreach $y_index (0 .. $y_index_max) {
            foreach my $direction (keys %{DIRECTIONS()}) {
                my $dx = ${DIRECTIONS()}{$direction}[0];
                my $dy = ${DIRECTIONS()}{$direction}[1];

                $word_count++ if word_starting_at(
                    \@matrix, $x_index, $y_index, $x_index_max, $y_index_max, length XMAS, $dx, $dy) eq XMAS;
            }
        }
    }

    $word_count;
}

sub part_2 {
    my $x_mas_count = 0;
    my $x_index = 0;
    my $x_index_max;
    my $y_index = 0;
    my $y_index_max = @_ - 1;
    my @valid_words = qw/MAS SAM/;
    my @matrix;
    my @row;

    foreach (@_) {
        @row = split //;

        for $y_index (0 .. @row - 1) {
            $matrix[$x_index][$y_index] = $row[$y_index];
        }
        $x_index++;
    }

    $x_index_max = $x_index - 1;

    foreach $x_index (1 .. $x_index_max - 1) {
        foreach $y_index (1 .. $y_index_max - 1) {
            my ($word_1, $word_2) = three_letter_words_crossing_at(\@matrix, $x_index, $y_index);

            $x_mas_count++ if (grep /^$word_1$/, @valid_words) && (grep /^$word_2$/, @valid_words);
        }
    }

    $x_mas_count;
}

1;
