package WWW::Mechanize::GPX2020;
#use lib '/data/workspaces/WWW-Mechanize-GPX2020/lib';
require WWW::Mechanize::GPX2020::Config;
use Any::Moose;
use Method::Signatures;
use v5.10.0;
use Data::Dumper;
use Carp;
use WWW::Mechanize;
use YAML::Tiny;
use URI;

=head1 NAME

WWW::Mechanize::GPX2020 - The great new WWW::Mechanize::GPX2020!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

This Modul can be used to change Config in 

    use WWW::Mechanize::GPX2020;

    my $foo = WWW::Mechanize::GPX2020->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 function1

=cut


has 'url'        => ( is => 'rw' , isa => 'Str', predicate => '_has_url', where => sub { $_[0] =~ m/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/ } );
has 'password'   => ( is => 'rw' , isa => 'Str', predicate => '_has_password');
has 'pwd_new'    => ( is => 'rw' );
has 'config'    => ( is => 'rw', isa => 'HashRef[Str]');
has 'agent'      => ( is => 'rw', isa => 'Object', default => sub { return WWW::Mechanize->new( quiet => 1) } );

=head2 function2
#        my $agent = WWW::Mechanize->new( onerror => sub { say "Error: $self->url" }, quiet => 1);
#        $agent->timeout(3);
#        my $login_res = login($agent,$self->url);
#        next if $login_res == 0;
#        print "Eingeloggd: $self->url";
#        changes($agent,$self->url);
#        print  "- changed -";
#        reboot($agent,$self->url);
#        say " fertig"      if $login_res == 1;
#        say "Fehler beim neustart" if $login_res == 0;
=cut
=head2 logon
        
        TODO: Document login
=cut

method logon ( :$url , :$password ) {
        $self->url($url)           if $url;
        $self->password($password) if $password;
        $self->config( {'P2' => $self->password}  );
        my $result = $self->agent->get($self->url);
        return 0 if not $result->is_success;
        $self->agent->form_number('1');
        $self->agent->field('P2',$self->config->{P2});
        my $r = $self->agent->submit();
        say "Falsches Kennwort: $self->url" if ($self->agent->content() =~ /Entschuldigung/);
        return 0 if not ($self->agent->content() =~ /STATUS/);
        $self->agent->get($url."index.htm");
        return 1;
};

=pod
#
#=head2 changes
#
#	TODO: Document changes
#
#=cut
#method changes {
#        ###
#        #
#        # Basic Config
#        #
#        ###
#        my $agent = shift;
#        my $url   = shift;
#        
#        $agent->get($url.'config2.htm' );     
#                $agent->submit_form(
##                fields =>  {%default_conf}
#                );
##                        say $agent->content;
# 
#        ###
#        #
#        # Extended Config
#        #
#        ###
#                );
#        };
=cut 
=head2 make_active
     Startet das Telefon neu
=cut

method make_active2 {
        $self->agent->get( $self->url().'/rs.htm');
        return 0 if ($self->agent->content() =~ /Entschuldigung/);
        return 1;
};

method make_active{};
method change_pwd {
        $self->config->{extended}{P2} = shift;
        };
method change_userpwd {
        $self->config->{default}{P196} = shift;
        };

method dump_forms( :$page ) {
        $self->agent->get($self->url.$page)  if $page;
        my $form = $self->agent->form_number('1');
        say $form->dump;
        };

method change_formfield {
        my %forms = %{$_[0]};
        $self->agent->get($self->url.'config.htm');
        foreach my $field ( keys %forms ){
                $self->agent->field( $field => $forms{$field});
        };
        $self->agent->submit();
}

###
#
###
method submit_changes {
# so war es mal => $agent->submit_form( fields => {%extended_conf} );

        #Basic Settings
        $self->agent->get($self->url.'config2.htm');
        foreach my $field ( keys %{ $self->config->{'default'} } ){
                say $field .' '. $self->config->{'default'}{$field};
                $self->agent->field( $field => $self->config->{'default'}{$field} );
        };
        $self->agent->submit();

        #Extended Settings
        $self->agent->get($self->url.'config.htm');
        foreach my $field ( keys %{ $self->config->{'extended'} } ){
                say $field .' '. $self->config->{'extended'}{$field};
                $self->agent->field( $field => $self->config->{'extended'}{$field} );
        };
        $self->agent->submit();
        #Und die Accounts.
        #Account1
        # http://192.168.200.182/config_a1.htm
        #Account2
        # http://192.168.200.182/config_a2.htm
        #Account3
        # http://192.168.200.182/config_a3.htm
        #Account4
        # http://192.168.200.182/config_a4.htm
        #Account5
        # http://192.168.200.182/config_a5.htm
        #Account6
        # http://192.168.200.182/config_a6.htm
#        $self->agent->field('P2',$self->agent->config->{extended}{P2});
};
#=head1 AUTHOR
#
#Matthias Ries, C<< <riesm at mad4milk.de> >>
#
#=head1 BUGS
#
#Please report any bugs or feature requests to C<bug-www-mechanize-gpx2020 at rt.cpan.org>, or through
#the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Mechanize-GPX2020>.  I will be notified, and then you'll
#automatically be notified of progress on your bug as I make changes.
#
#
#
#
#=head1 SUPPORT
#
#You can find documentation for this module with the perldoc command.
#
#    perldoc WWW::Mechanize::GPX2020
#
#
#You can also look for information at:
#
#=over 4
#
#=item * RT: CPAN's request tracker
#
#L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Mechanize-GPX2020>
#
#=item * AnnoCPAN: Annotated CPAN documentation
#
#L<http://annocpan.org/dist/WWW-Mechanize-GPX2020>
#
#=item * CPAN Ratings
#
#L<http://cpanratings.perl.org/d/WWW-Mechanize-GPX2020>
#
#=item * Search CPAN
#
#L<http://search.cpan.org/dist/WWW-Mechanize-GPX2020/>
#
#=back
#
#
#=head1 ACKNOWLEDGEMENTS
#       
#
#=head1 COPYRIGHT & LICENSE
#
#Copyright 2009 Matthias Ries, all rights reserved.
#
#This program is released under the following license: lgpl
#=cut

1; # End of WWW::Mechanize::GPX2020


