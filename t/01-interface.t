use Test::More tests => 29;

BEGIN {
    BAIL_OUT('Error loading Acme::Playmate')
        unless use_ok('Acme::Playmate');
}

my $m = 'Acme::Playmate';

can_ok($m, qw/birthplace bust waist hips height
              weight questions next previous link/
);

my $bunny;

for (0..13) {
    $bunny = $m->new(1952, $_);
    is($bunny, undef);
}

for (1..11) {
    $bunny = $m->new(1953, $_);
    is($bunny, undef);
}

$bunny = $m->new(2000, 0);
is ($bunny, undef);
$bunny = $m->new(2000, 13);
is ($bunny, undef);
