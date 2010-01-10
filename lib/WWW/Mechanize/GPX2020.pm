package WWW::Mechanize::GPX2020;
use lib '/data/workspaces/WWW-Mechanize-GPX2020/lib';
require WWW::Mechanize::GPX2020::Config;
use Any::Moose;
use Method::Signatures;
use v5.10.0;
use Carp;
use WWW::Mechanize;
use YAML::Tiny;
use URI;

=head1 NAME

WWW::Mechanize::GPX2020 - Automize the GPX2020 Configuration

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

This Modul can be used to change the configuration of GPX2020 voip-phones 

    use WWW::Mechanize::GPX2020;

    my $foo = WWW::Mechanize::GPX2020->new();
    ...
=cut

has 'url'        => ( is => 'rw' , isa => 'Str', predicate => '_has_url', where => sub { $_[0] =~ m/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/ } );
has 'password'   => ( is => 'rw' , isa => 'Str', predicate => '_has_password');
has 'pwd_new'    => ( is => 'rw' );
has 'config'    => ( is => 'rw', isa => 'HashRef[Str]');
has 'agent'      => ( is => 'rw', isa => 'Object', default => sub { return WWW::Mechanize->new( quiet => 1) } );


method logon ( :$url , :$password ) {
        $self->url($url)           if $url;
        $self->password($password) if $password;
        $self->config( {'P2' => $self->password } );
        my $result = $self->agent->get($self->url);
        return 0 if not $result->is_success;
        $self->agent->form_number('1');
        $self->agent->field('P2',$self->config->{P2});
        my $r = $self->agent->submit();
        say "Falsches Kennwort: $self->url" if ($self->agent->content() =~ /Entschuldigung/);
        return 0 if not ($self->agent->content() =~ /STATUS/);
        $self->agent->get($url."index.htm");
        say $self->agent->content();
        return 1;
};

method changes {
        $agent->get($url.'config2.htm' );     
                $agent->submit_form(
                fields =>  {%default_conf}
                );
        # Extended Config
        $agent->get($url.'config.htm');
                $agent->submit_form( 
                        fields => {%extended_conf}
                );
        };

method make_active2 {
        $self->agent->get( $self->url().'/rs.htm');
        return 0 if ($self->agent->content() =~ /Entschuldigung/);
        return 1;
};

method make_active{};
method change_pwd {
        $self->config->{P2}
                $self->agent->field('P2',$extended_conf{P2});
        };
method change_userpwd {};


=head1 AUTHOR

Matthias Ries, << <matthias at mad4milk.de> >>

=head1 BUGS

Please report any bugs or feature requests to C<matthias at mad4milk.de>, or through

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Mechanize::GPX2020


You can also look for information at:

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2009 Matthias Ries, all rights reserved.

This program is released under the following license: lgpl
=cut

1;
