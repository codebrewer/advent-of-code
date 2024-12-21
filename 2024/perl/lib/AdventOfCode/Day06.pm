package AdventOfCode::Day06;

use strict;
use warnings FATAL => 'all';
use Sub::Exporter -setup => {
    exports => [ qw(part_1 part_2) ],
};
use constant DIRECTIONS => {
    north => [ 0, -1 ],
    east  => [ 1, 0 ],
    south => [ 0, 1 ],
    west  => [ -1, -0 ]
};
use constant NEXT_DIRECTION_NAMES => {
    north => 'east',
    east  => 'south',
    south => 'west',
    west  => 'north'
};
use constant GUARD => '^';
use constant OBSTRUCTION => '#';
use constant NEW_OBSTRUCTION => 'O';
use constant UNVISITED => '.';
use constant VISITED => 'X';

sub part_1 {
    my $guard_x_index;
    my $guard_y_index;
    my $guard_direction_name = 'north';
    my $x_index = 0;
    my $x_index_max;
    my $y_index = 0;
    my $y_index_max = @_ - 1;
    my @matrix;
    my @row;
    my @visited_positions;

    foreach (@_) {
        @row = split //;
        $x_index_max = @row - 1;

        for $x_index (0 .. $x_index_max) {
            $matrix[$x_index][$y_index] = { content => $row[$x_index] };
            $guard_x_index = $x_index, $guard_y_index = $y_index if $row[$x_index] eq GUARD
        }

        $y_index++;
    }

    while ($guard_x_index > 0 &&
        $guard_x_index < $x_index_max &&
        $guard_y_index > 0 &&
        $guard_y_index < $y_index_max) {

        my $guard_direction = ${DIRECTIONS()}{$guard_direction_name};
        my $guard_dx = @$guard_direction[0];
        my $guard_dy = @$guard_direction[1];

        if ($matrix[$guard_x_index + $guard_dx][$guard_y_index + $guard_dy]->{content} eq OBSTRUCTION) {
            $guard_direction_name = ${NEXT_DIRECTION_NAMES()}{$guard_direction_name};
        }
        else {
            if (not $matrix[$guard_x_index + $guard_dx][$guard_y_index + $guard_dy]->{content} eq VISITED) {
                $matrix[$guard_x_index + $guard_dx][$guard_y_index + $guard_dy] ={
                    content => VISITED,
                    direction => $guard_direction_name
                };
                push @visited_positions, [ $guard_x_index + $guard_dx, $guard_y_index + $guard_dy ];
            }

            $guard_x_index += $guard_dx;
            $guard_y_index += $guard_dy;
        }
    }

    \@visited_positions;
}

sub part_2 {
    my $visited_positions_ref = part_1(@_);
    my $proven_loop_count = 0;
    my $assumed_loop_count = 0;

    for my $visited_location (@$visited_positions_ref) {
        my ($new_obstruction_x_index, $new_obstruction_y_index) = @$visited_location;
        my $guard_x_index;
        my $guard_y_index;
        my $guard_direction_name = 'north';
        my $x_index = 0;
        my $x_index_max;
        my $y_index = 0;
        my $y_index_max = @_ - 1;
        my @matrix = [];
        my @row;
        my $guard_moves_made = 0;

        foreach (@_) {
            @row = split //;
            $x_index_max = @row - 1;

            for $x_index (0 .. $x_index_max) {
                if ($row[$x_index] eq GUARD) {
                    $guard_x_index = $x_index;
                    $guard_y_index = $y_index;
                    $matrix[$x_index][$y_index] = { content => UNVISITED };
                }
                else {
                    $matrix[$x_index][$y_index] = { content => $row[$x_index] };
                }
            }

            $y_index++;
        }

        $matrix[$new_obstruction_x_index][$new_obstruction_y_index]->{content} = NEW_OBSTRUCTION;

        while ($guard_x_index > 0 &&
            $guard_x_index < $x_index_max &&
            $guard_y_index > 0 &&
            $guard_y_index < $y_index_max) {

            my $guard_direction = ${DIRECTIONS()}{$guard_direction_name};
            my $guard_dx = @$guard_direction[0];
            my $guard_dy = @$guard_direction[1];

            $matrix[$guard_x_index][$guard_y_index]->{content} = VISITED;
            $matrix[$guard_x_index][$guard_y_index]->{direction_on_entry} = $guard_direction_name;

            my $current_location_data_ref = $matrix[$guard_x_index][$guard_y_index];
            my $next_location_data_ref = $matrix[$guard_x_index + $guard_dx][$guard_y_index + $guard_dy];

            if ($guard_moves_made > $x_index_max * $y_index_max) {
                $assumed_loop_count++;
                last;
            }

            if (($next_location_data_ref->{content} eq NEW_OBSTRUCTION || $next_location_data_ref->{content} eq OBSTRUCTION) &&
                exists $current_location_data_ref->{direction_on_exit} &&
                $current_location_data_ref->{direction_on_exit} eq ${NEXT_DIRECTION_NAMES()}{$guard_direction_name}) {
                $proven_loop_count++;
                last;
            }

            if ($next_location_data_ref->{content} eq NEW_OBSTRUCTION || $next_location_data_ref->{content} eq OBSTRUCTION) {
                $matrix[$guard_x_index][$guard_y_index] = {
                    content            => VISITED,
                    direction_on_entry => $guard_direction_name,
                    direction_on_exit  => ${NEXT_DIRECTION_NAMES()}{$guard_direction_name}
                };
                $guard_direction_name = ${NEXT_DIRECTION_NAMES()}{$guard_direction_name};
            }
            else {
                $matrix[$guard_x_index][$guard_y_index] = {
                    content => VISITED,
                    direction_on_entry => $guard_direction_name,
                    direction_on_exit => $guard_direction_name
                };
                $guard_x_index += $guard_dx;
                $guard_y_index += $guard_dy;
                $guard_moves_made++;
            }
        }
    }

    $proven_loop_count + $assumed_loop_count;
}

1;
