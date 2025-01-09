package AdventOfCode::Day07;

use strict;
use warnings FATAL => 'all';
use Sub::Exporter -setup => {
    exports => [ qw(part_1 part_2) ],
};
use Math::Base::Convert qw(cnv);

sub split_input_data {
    my @input_data;

    foreach (@_) {
        $_ =~ /^(\d+): (.*)$/;
        my $test_value = $1;
        my @operands = split /\s+/, $2;

        push @input_data, { test_value => $test_value, operands   => [ @operands ] };
    }

    \@input_data;
}

sub addition_operator {
    my ($operand_1, $operand_2) = @_;

    $operand_1 + $operand_2;
}

sub concatenation_operator {
    my ($operand_1, $operand_2) = @_;

    "$operand_1$operand_2";
}

sub multiplication_operator {
    my ($operand_1, $operand_2) = @_;

    $operand_1 * $operand_2;
}

sub permute_operators {
    my ($operand_count, @operators) = @_;
    die "Fatal: operand count $operand_count must be greater than 1" if not $operand_count > 1;
    my $operator_count = @operators;
    my $operation_count = $operand_count - 1;
    my $permutation_count = @operators ** $operation_count;
    my $base_n_encoding = [ 0 .. $operator_count - 1 ];
    my $base_n_format_specifier = "%0${operation_count}s";
    my @operator_permutations;

    foreach (0 .. $permutation_count - 1) {
        my $base3_permutation = sprintf($base_n_format_specifier, scalar cnv $_, 10 => $base_n_encoding);
        my @operator_permutation;

        foreach (split "", $base3_permutation) {
            push @operator_permutation, $operators[$_];
        }

        push @operator_permutations, [@operator_permutation];
    }

    \@operator_permutations;
}

my %operations_dispatch_table = (
    add         => \&addition_operator,
    concatenate => \&concatenation_operator,
    multiply    => \&multiplication_operator
);

sub part_1_using_bitwise_operations {
    my $input_data_ref = split_input_data(@_);
    my $total_calibration_result = 0;

    foreach (@$input_data_ref) {
        my $test_value = $_->{test_value};
        my $operands_ref = $_->{operands};
        my $operation_count = @$operands_ref - 1;
        my $operation_permutation_count = 2 ** $operation_count;

        foreach my $operation_permutation (0 .. $operation_permutation_count - 1) {
            my @operations;
            foreach my $operation_index (0 .. $operation_count - 1) {
                push @operations, (($operation_permutation & 2 ** $operation_index) == 0 ? 'add' : 'multiply');
            }

            my $operation_permutation_calibration_result = 0;

            foreach my $foo_index (0 .. $operation_count - 1) {
                my $operand_1 = $foo_index == 0 ?
                    @$operands_ref[$foo_index * 2] : $operation_permutation_calibration_result;
                my $operand_2 = @$operands_ref[$foo_index + 1];

                $operation_permutation_calibration_result =
                    $operations_dispatch_table{$operations[$foo_index]}->($operand_1, $operand_2);
            }

            if ($operation_permutation_calibration_result == $test_value) {
                $total_calibration_result += $test_value;
                last;
            }
        }
    }

    $total_calibration_result;
}

sub solve {
    my $operators_ref = shift;
    my $input_data_ref = split_input_data(@_);
    my $total_calibration_result = 0;
    my %operator_permutations_by_operand_count;

    foreach (@$input_data_ref) {
        my $test_value = $_->{test_value};
        my $operands_ref = $_->{operands};
        my $operand_count = @$operands_ref;

        if (not exists $operator_permutations_by_operand_count{$operand_count}) {
            $operator_permutations_by_operand_count{$operand_count} =
                permute_operators $operand_count, @$operators_ref;
        }

        my $operator_permutation_ref = $operator_permutations_by_operand_count{$operand_count};

        foreach my $operator_permutation (@$operator_permutation_ref) {
            my $operation_count = @$operands_ref - 1;
            my $operation_permutation_calibration_result = 0;

            foreach my $operand_index (0 .. $operation_count - 1) {
                my $operand_1 = $operand_index == 0 ?
                    @$operands_ref[$operand_index] : $operation_permutation_calibration_result;
                my $operand_2 = @$operands_ref[$operand_index + 1];

                $operation_permutation_calibration_result =
                    $operations_dispatch_table{@$operator_permutation[$operand_index]}->($operand_1, $operand_2);
            }

            if ($operation_permutation_calibration_result == $test_value) {
                $total_calibration_result += $test_value;
                last;
            }
        }
    }

    $total_calibration_result;
}

sub part_1 {
    solve [qw(add multiply)], @_;
}

sub part_2 {
    solve [qw(add concatenate multiply)], @_;
}

1;
