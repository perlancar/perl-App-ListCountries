package App::ListCountries;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Perinci::Sub::Gen::AccessTable qw(gen_read_table_func);

our %SPEC;
use Exporter qw(import);
our @EXPORT_OK = qw(list_countries);

our $data;
{
    require Locale::Codes::Country_Codes;
    $data = [];
    my $id2names  = $Locale::Codes::Data{'country'}{'id2names'};
    my $id2alpha2 = $Locale::Codes::Data{'country'}{'id2code'}{'alpha-2'};

    for my $id (keys %$id2names) {
        push @$data, [$id2alpha2->{$id}, $id2names->{$id}[0]];
    }

    $data = [sort {$a->[0] cmp $b->[0]} @$data];
}

my $res = gen_read_table_func(
    name => 'list_countries',
    summary => 'List countries',
    table_data => $data,
    table_spec => {
        summary => 'List of countries',
        fields => {
            alpha2 => {
                summary => 'ISO 2-letter code',
                schema => 'str*',
                pos => 0,
                sortable => 1,
            },
            en_name => {
                summary => 'English name',
                schema => 'str*',
                pos => 1,
                sortable => 1,
            },
        },
        pk => 'alpha2',
    },
    description => <<'_',

Source data is generated from `Locale::Codes::Country_Codes`. so make sure you
have a relatively recent version of the module.

_
);
die "Can't generate function: $res->[0] - $res->[1]" unless $res->[0] == 200;

1;
#ABSTRACT:

=head1 SYNOPSIS

 # Use via list-countries CLI script


=head1 SEE ALSO

L<Locale::Codes>

=cut
