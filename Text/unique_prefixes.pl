#!/usr/bin/perl

# Author: Daniel "Trizen" Șuteu
# License: GPLv3
# Date: 28 September 2014
# Website: http://github.com/trizen

# Find the unique prefixes for an array of arrays of strings

use 5.016;
use strict;
use warnings;

sub abbrev {
    my ($array, $code) = @_;

    my $__END__  = {};                     # some unique value
    my $__CALL__ = ref($code) eq 'CODE';

    my %table;
    foreach my $sub_array (@{$array}) {
        my $ref = \%table;
        foreach my $item (@{$sub_array}) {
            $ref = $ref->{$item} //= {};
        }
        $ref->{$__END__} = $sub_array;
    }

    my @abbrevs;
    sub {
        my ($hash) = @_;

        foreach my $key (my @keys = sort keys %{$hash}) {
            __SUB__->($hash->{$key}) if $key ne $__END__;

            if ($#keys > 0) {
                my $count = 0;
                my $ref = my $val = delete $hash->{$key};
                while (my ($key) = each %{$ref}) {
                    defined($key) && $key eq $__END__
                      ? do {
                        my $arr = [@{$ref->{$key}}[0 .. $#{$ref->{$key}} - $count]];
                        $__CALL__ ? $code->($arr) : push(@abbrevs, $arr);
                        last;
                      }
                      : ($ref = $val = $ref->{$key // last});
                    ++$count;
                }
            }
        }
      }
      ->(\%table);

    return \@abbrevs;
}

#
## Example: find the common directory from a list of dirs
#

my @dirs = qw(
  /home/user1/tmp/coverage/test
  /home/user1/tmp/covert/operator
  /home/user1/tmp/coven/members
  );

require List::Util;
my $unique_prefixes = abbrev([map { [split('/')] } @dirs]);
my %table = map { $#{$_} => $_ } @{$unique_prefixes};
my $min = List::Util::min(keys %table);
say join('/', splice(@{$table{$min}}, 0, -1));
