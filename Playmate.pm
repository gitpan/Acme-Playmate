package Acme::Playmate;

use 5.008;
use strict;
use warnings;

use LWP::UserAgent;

our @ISA = qw();

our $VERSION = '0.02';


my $url = "http://www.playboy.com/playmates/directory/";

sub new 
{
	my $class = shift;
	my ($year, $month ) = @_;
	$year = "1953" unless defined $year;
	$month = "12" unless defined $month;
	my $ua = LWP::UserAgent->new;
	$ua->agent("Acme::Playmate " . $VERSION);
	my $req = HTTP::Request->new(GET => $url . $year . $month . ".html");
	$req->header('Accept' => 'text/html');
	my $res = $ua->request($req);
	if(!$res->is_success) {
		die "Failed to fetch information: " . $res->status_line . " \n";
	}
	my $con = $res->content;
	$con =~ s/[\r\n]//g;
	$con =~ /.*?<span class="name">(.*?)<\/span>.*?/is;
	my $name = $1;
	my $self = {  Name => $name };
	bless $self, $class;
	return $self;
}
1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Acme::Playmate - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Acme::Playmate;
  $playmate = new Acme::Playmate();
  print $playmate{ "Name" };

=head1 ABSTRACT

  This should be the abstract for Acme::Playmate.
  The abstract is used when making PPD (Perl Package Description) files.
  If you don't want an ABSTRACT you should also edit Makefile.PL to
  remove the ABSTRACT_FROM option.

=head1 DESCRIPTION

Acme::Playmate is a Perl extension to consult the playboy playmate directory for playmate information.
Blah blah blah.

=head2 EXPORT

None.


=head1 SEE ALSO

=head1 AUTHOR

O. S. de Zwart, E<lt>olle@endforward.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by O. S. de Zwart

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
