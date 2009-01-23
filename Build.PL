use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Acme::Playmate',
    license             => 'perl',
    dist_author         => 'O. S. de Zwart <olle@endforward.nl>',
    dist_version_from   => 'lib/Acme/Playmate.pm',
    dist_abstract       => 'an object-oriented interface to playboy.com',
    build_requires => {
        'Test::More' => 0,
        'LWP::UserAgent' => 0,
    },
    add_to_cleanup      => [ 'Acme-Playmate-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
