package AdventOfCode::Day05;

use strict;
use warnings FATAL => 'all';
use Sub::Exporter -setup => {
    exports => [ qw(part_1 part_2) ],
};

sub split_input_data {
    my %rules_by_page_number;
    my @updates;
    my $reading_rules = 1;

    foreach (@_) {
        if (length == 0) {
            $reading_rules = 0;
            next;
        }

        if ($reading_rules == 1) {
            my ($page, $later_page) = split /\|/;

            push @{$rules_by_page_number{$page}}, $later_page;
        }
        else {
            push @updates, [ split /,/ ];
        }
    }

    my %input_data = (
        rules   => \%rules_by_page_number,
        updates => [ @updates ],
    );

    \%input_data;
}

sub validate_update {
    my ($rules_by_page_number_ref, $update_ref) = @_;
    my %validate_update_result = (is_valid => 1);

    foreach my $current_page (@$update_ref) {
        next if (not $rules_by_page_number_ref->{$current_page});

        my @later_pages = @{$rules_by_page_number_ref->{$current_page}};

        foreach my $earlier_page (@$update_ref) {
            if ($earlier_page == $current_page) {
                last;
            }

            foreach my $page_that_should_be_later_than_current_page (@later_pages) {
                if ($page_that_should_be_later_than_current_page == $earlier_page) {
                    $validate_update_result{'is_valid'} = 0;
                    push @{$validate_update_result{'violated_rules'}}, "$current_page|$page_that_should_be_later_than_current_page";
                }
            }
        }
    }

    \%validate_update_result;
}

sub part_1 {
    my $input_data_ref = split_input_data(@_);
    my $rules_by_page_number_ref = $input_data_ref->{'rules'};
    my $page_numbers_by_update_number_ref = $input_data_ref->{'updates'};
    my $middle_page_number_sum = 0;

    foreach my $update_ref (@$page_numbers_by_update_number_ref) {
        if (validate_update($rules_by_page_number_ref, $update_ref)->{'is_valid'} == 1) {
            $middle_page_number_sum += @$update_ref[@$update_ref / 2];
        }
    }

    $middle_page_number_sum;
}

sub part_2 {
    my $input_data_ref = split_input_data(@_);
    my $rules_by_page_number_ref = $input_data_ref->{'rules'};
    my $page_numbers_by_update_number_ref = $input_data_ref->{'updates'};
    my $middle_page_number_sum = 0;

    foreach my $update_ref (@$page_numbers_by_update_number_ref) {
        my $validate_update_result_ref = validate_update($rules_by_page_number_ref, $update_ref);

        next if $validate_update_result_ref->{'is_valid'} == 1;

        while (not $validate_update_result_ref->{'is_valid'}) {
            foreach my $violated_rule (@{$validate_update_result_ref->{'violated_rules'}}) {
                my @reordered_update;
                my ($misordered_page, $later_page) = split /\|/, $violated_rule;

                foreach my $current_page (@$update_ref) {
                    next if $current_page == $later_page;
                    push @reordered_update, $current_page if $current_page != $later_page;
                    push @reordered_update, $later_page if $current_page == $misordered_page;
                }

                $update_ref = \@reordered_update;
            }

            $validate_update_result_ref = validate_update($rules_by_page_number_ref, $update_ref);
        }

        $middle_page_number_sum += @$update_ref[@$update_ref / 2];
    }

    $middle_page_number_sum;
}

1;
