package Acme::Playmate;
use LWP::UserAgent;

use warnings;
use strict;

our $VERSION = '0.04';

sub new {
    my ($class, $year, $month ) = @_;
    my $self = {
        'year'  => (defined $year ) ? $year  : undef,
        'month' => (defined $month) ? $month : undef,
    };
    bless $self, $class;

    if ($self->_fetch_bunny()) {
        return $self;
    }
    else {
        return undef;
    }
}

sub _get_url {
    my $self = shift;
    
    if (not defined $self->{'year'}) {
        $self->{'year'}  = 1953;
        $self->{'month'} = 12;
    }
    else {
        # make sure $year is numeric
        # to avoid warnings
        $self->{'year'} = sprintf "%u", $self->{'year'};
        
        # sanity check
        return undef unless $self->{'year'} >= 1953;
        
        if (defined $self->{'month'}) {
            # sanity checks (1st issue and ilegal month values)
            if ( ($self->{'year'} == 1953 and $self->{'month'} < 12)
              or ($self->{'month'} < 1) or ($self->{'month'} > 12)
            ) {
                return undef;
            }
            
            # leading zero required for website
            $self->{'month'} = sprintf "%02u", $self->{'month'};
        }
        else {
            return undef; #TODO: should return URL for playmate of the year
        }
    }

    $self->{'link'} = 'http://www.playboy.com/girls/playmates/directory/' 
                    . $self->{'year'} . $self->{'month'} . '.html'
                    ;
    return $self->{'link'};
}

sub _fetch_bunny {
    my $self = shift;
    
    # formats url
    return undef unless $self->_get_url();
    
    # tries to fetch playboy's website
    my $ua = LWP::UserAgent->new;
    $ua->agent('Acme::Playmate ' . $VERSION);
    my $req = HTTP::Request->new(GET => $self->link() );
    $req->header('Accept' => 'text/html');
    my $res = $ua->request($req);
    if(!$res->is_success) {
        warn "Failed to fetch playmate information: " . $res->status_line . " \n";
        return undef;
    }
    
    my $con = $res->content;
    # yes, I know we should be using an actual scraping
    # framework... but, hey, this is Acme, so back off :)
    if ($con =~ /.*?<span class="pmd_pm_name">(.*?)<\/span>.*?/s) {
        $self->{'name'} = $1;
    }
    if ($con =~ /.*?<b>BIRTHPLACE:<\/b>\s*(.*?)\s*<br \/>.*?/s) {
        $self->{'birthplace'} = $1;
    }
    if ($con =~ /.*?<b>BUST:<\/b>\s*(.*?)\s*<br \/>.*?/s) {
        $self->{'bust'} = $1;
    }
    if ($con =~ /.*?<b>WAIST:<\/b>\s*(.*?)\s*<br \/>.*?/s) {
        $self->{'waist'} = $1;
    }
    if ($con =~ /.*?<b>HIPS:<\/b>\s*(.*?)\s*<br \/>.*?/s) {
        $self->{'hips'} = $1;
    }
    if ($con =~ /.*?<b>HEIGHT:<\/b>\s*(.*?)\s*<br \/>.*?/s) {
        $self->{'height'} = $1;
    }
    if ($con =~ /.*?<b>WEIGHT:<\/b>\s*(.*?)\s*<br \/>.*?/s) {
        $self->{'weight'} = $1;
    }
}

sub name {
    my $self = shift;
    return $self->{'name'};
}

sub birthplace {
    my $self = shift;
    return $self->{'birthplace'};
}

sub bust {
    my $self = shift;
    return $self->{'bust'};
}

sub waist {
    my $self = shift;
    return $self->{'waist'};
}

sub hips {
    my $self = shift;
    return $self->{'hips'};
}

sub height {
    my $self = shift;
    return $self->{'height'};
}

sub weight {
    my $self = shift;
    return $self->{'weight'};
}

sub link {
    my $self = shift;
    return $self->{'link'};
}

sub next {
    my $self = shift;
    $self->{'month'}++;
    
    if ($self->{'month'} > 12) {
        $self->{'year'}++;
        $self->{'month'} = 1;
    }
    $self->_fetch_bunny();
}

sub previous {
    my $self = shift;
    $self->{'month'}--;
    
    if ($self->{'month'} < 1) {
        $self->{'year'}--;
        $self->{'month'} = 12;
    }
    $self->_fetch_bunny();
}

sub questions {
}

42;
__END__
=head1 NAME

Acme::Playmate - An object-oriented interface to playboy.com

=head1 VERSION

Version 0.04

=head1 SYNOPSIS

    use Acme::Playmate;

    my $bunny = Acme::Playmate->new(2007, 1);
    
    print "Details for playmate " . $bunny->name() . "\n"; # Jayde Nicole
    
    print "Birthplace: " . $bunny->birthplace() . "\n";  # 'Scarborough, Ontario'
    print "Bust: "       . $bunny->bust()       . "\n";  # 34" C
    print "Waist: "      . $bunny->waist()      . "\n";  # 24
    print "Hips: "       . $bunny->hips()       . "\n";  # 35
    print "Height: "     . $bunny->height()     . "\n";  # 5' 9"
    print "Weight: "     . $bunny->weight()     . "\n";  # 117 lbs
    
    $bunny->next();      # goes to next month's playmate
    $bunny->previous();  # goes to previous month's playmate
    
    $bunny->link();      # link to oficial playboy.com's Playmate Directory

    # (not yet implemented)
    while (my ($q, $a) = each $bunny->questions) {
        print "$q\n";  # ambitions, turn-ons, good first date, ...
        print "$a\n";  # answers! Feeling lucky? ;)
    }


=head1 DESCRIPTION

Acme::Playmate lets you browse all of Playboy's "Playmate of the Month" (a.k.a. Centerfolds) information.

=head2 new ( YYYY, MM )

Intantiates a new playmate. Receives year and month as parameters. If the month is omitted, fetches the 'Playmate of the Year' (feature is not yet implemented). If no parameter is given, defaults to the first playmate ever (The eternal Marilyn Monroe, December 1953). Returns undef if unable to fetch information.

=head2 name, birthplace, bust, waist, hips, height, weight

I think those are self-explanatory :)

=head2 questions

(not yet implemented)

Should return questions and answers from the Playmate's Data Sheet

=head2 link

Returns the Playboy's website URL for the selected Playmate's directory.

=head2 previous

...and now your object is the Playmate of the previous month. Returns undef if there is none.

=head2 next

...and now your object is the Playmate of the following month. Returns undef if there is none.

=head1 AUTHOR

Olle S. de Zwart, C<< <olle at endforward.nl> >>

Currently mantained by Breno G. de Oliveira C<< <garu at cpan.org> >>

=head1 BUGS AND LIMITATIONS

Due to copyright restrictions, information cannot be cached, so you'll need an active Internet connection to use this module.

Please report any bugs or feature requests to C<bug-acme-playmate at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Acme-Playmate>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Acme::Playmate


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Acme-Playmate>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Acme-Playmate>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Acme-Playmate>

=item * Search CPAN

L<http://search.cpan.org/dist/Acme-Playmate/>

=back


=head1 ACKNOWLEDGEMENTS

Many thanks to the playboy.com team for putting the playmates' contents online for the readers.

=head1 SEE ALSO

Playboy's Website: L<< http://www.playboy.com >>

=head1 COPYRIGHT & LICENSE

This module is Copyright 2000-2009 O. S. de Zwart, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

This module is not affiliated with Playboy or playboy.com in any way.

The contents of the Playboy Internet service ("the Service"), including all Sites, are intended for the personal, noncommercial use of its users. All materials published on the Sites (including, but not limited to articles, photographs, images, illustrations, product descriptions, audio clips and video clips (collectively, the "Content")) are protected by copyright, trademark and all other applicable intellectual property laws, and are owned or controlled by Playboy Enterprises, Inc. or the party credited as the provider of such Content, software or other materials. You shall abide by copyright or other notices, information and restrictions appearing in conjunction with any Content accessed through the Service.
The Service is protected by copyright as a collective work and/or compilation, pursuant to U.S. copyright laws, international conventions and other copyright laws. Except as may otherwise be set forth on the Terms of Service, you may not modify, adapt, translate, exhibit, publish, transmit, participate in the transfer or sale of, create derivative works from, distribute, perform, display, reverse engineer, decompile or dissemble, or in any way exploit, any of the Content, software, materials, Sites or Service in whole or in part.

Please refer to L<< http://www.playboy.com/help/legal_notices.html >> for further information.