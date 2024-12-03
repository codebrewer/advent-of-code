package AdventOfCode::Util;

use autodie;
use strict;
use warnings FATAL => 'all';
use Sub::Exporter -setup => {
    exports => [ 'slurp_input' ],
};

sub slurp_input {
    open my $INPUT, '<', $_[0];
    chomp(my @input = <$INPUT>);
    close $INPUT;
    @input
}

1;
