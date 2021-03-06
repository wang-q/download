#!/usr/bin/perl
use strict;
use warnings;
use autodie;

package Urlcheck;
use Moose;
use File::Spec;
use Path::Class;
use URI;
use URI::Split qw(uri_split uri_join);

has 'site'        => ( is => 'rw', isa => 'Str', required => 1, );
has 'remote_base' => ( is => 'rw', isa => 'Str', required => 1, );
has 'local_base'  => ( is => 'rw', isa => 'Str', required => 1, );

# key => url; value => localpath
has 'url_path' => ( is => 'rw', isa => 'HashRef', default => sub { {} } );
has 'url_bad'  => ( is => 'rw', isa => 'HashRef', default => sub { {} } );

has 'dir_to_mk' => ( is => 'rw', isa => 'HashRef', default => sub { {} } );
has 'verbose' => ( is => 'rw', isa => 'Bool', default => 0, );

has 'not_check_parent' => ( is => 'rw', isa => 'Bool', default => 0, );

# in the same site
sub check_site {
    my $self = shift;
    my $url  = shift;

    my $site = $self->site;

    my ( $scheme, $auth, $path, $query, $frag ) = uri_split($url);
    return $site eq $auth;
}

# be the child of $remote_base
sub check_parent {
    my $self = shift;
    my $url  = shift;

    my $remote_base = $self->remote_base;

    my ( $scheme, $auth, $path, $query, $frag ) = uri_split($url);

    if ( index( $path, $remote_base ) == 0 ) {
        if ( length $path >= length $remote_base ) {
            return 1;
        }
    }
    else {
        print "path => [$path]\tremote_base => [$remote_base]\n"
            if $self->verbose;
        return 0;
    }
}

# doesn't have query and frag
sub check_clean {
    my $self = shift;
    my $url  = shift;
    my ( $scheme, $auth, $path, $query, $frag ) = uri_split($url);

    if ( defined $query or defined $frag ) {
        return 0;
    }

    return 1;
}

sub remote_rel {
    my $self        = shift;
    my $url         = shift;
    my $remote_base = $self->remote_base;

    my ( $scheme, $auth, $path, $query, $frag ) = uri_split($url);
    my $remote_rel = File::Spec->abs2rel( $path, $remote_base );
    return uri_join( undef, undef, $remote_rel, $query, $frag );
}

# find good url then return 1
sub add_url {
    my $self     = shift;
    my $url      = shift;
    my $url_path = $self->url_path;
    my $url_bad  = $self->url_bad;

    if ( $self->check_site($url) ) {
        if ( $self->not_check_parent or $self->check_parent($url) ) {
            if ( $self->check_clean($url) ) {
                $url_path->{$url} = undef;
                printf "* %s ==> [ADD]\n", $self->remote_rel($url)
                    if $self->verbose;
                return 1;
            }
            else {
                $url_bad->{$url} = undef;
                printf "* %s ==> [BAD]\n", $self->remote_rel($url)
                    if $self->verbose;
                print "check_clean failed\n" if $self->verbose;
                return 0;
            }
        }
        else {
            $url_bad->{$url} = undef;
            printf "* %s ==> [BAD]\n", $self->remote_rel($url)
                if $self->verbose;
            print "check_parent failed\n" if $self->verbose;
            return 0;
        }
    }
    else {
        $url_bad->{$url} = undef;
        printf "* %s ==> [BAD]\n", $self->remote_rel($url) if $self->verbose;
        print "check_site failed\n" if $self->verbose;
        return 0;
    }
}

sub already_met {
    my $self     = shift;
    my $url      = shift;
    my $url_path = $self->url_path;
    my $url_bad  = $self->url_bad;

    if ( exists $url_path->{$url} or exists $url_bad->{$url} ) {
        printf "* %s ==> [MET]\n", $self->remote_rel($url) if $self->verbose;
        return 1;
    }
    return 0;
}

sub local_path {
    my $self = shift;
    my $url  = shift;

    my $remote_base = $self->remote_base;
    my $local_base  = $self->local_base;
    my $dir_to_mk   = $self->dir_to_mk;

    my $remote_path;
    {
        my ( $scheme, $auth, $path, $query, $frag ) = uri_split($url);
        my ( $vol, $dirs, $file ) = File::Spec->splitpath($path);

        my $rx = quotemeta $remote_base;
        $path =~ s/$rx//;

        if ( !$file ) {
            $path .= 'index.html';
        }
        $remote_path = $path;
    }

    my $local_path = file( $local_base, $remote_path );

    {
        my $dir = $local_path->dir->stringify;
        $dir_to_mk->{$dir}++;
    }

    return $local_path->stringify;
}

sub convert_all {
    my $self     = shift;
    my $url_path = $self->url_path;

    for my $key ( sort keys %{$url_path} ) {
        $url_path->{$key} = $self->local_path($key);
    }
}

1;

package main;
use Getopt::Long qw(HelpMessage);
use YAML qw(Dump Load DumpFile LoadFile);

use URI;
use URI::Split qw(uri_split uri_join);

use LWP::Simple;
use WWW::Mechanize;
use File::Spec;

#----------------------------------------------------------#
# GetOpt section
#----------------------------------------------------------#

=head1 NAME

list.pl - Walking through a http site

=head1 SYNOPSIS

    perl list.pl [options]
      Options:
        --help          -?          brief help message
        --url           -u  STR     url of http site
        --dir           -d  STR     default is [.]
        --regex         -r  STR     regex to avoid url
        --ncp                       Not check parent

    perl list.pl -u http://mus.well.ox.ac.uk/19genomes/fasta/

Don't include index.html in URL.

=cut

# store command line before GetOptions
my $cmdline = join " ", ( $0, @ARGV );

GetOptions(
    'help|?'  => sub { HelpMessage(0) },
    'url|u=s' => \( my $main_url ),
    'dir|d=s'   => \( my $working_dir      = '.' ),
    'regex|r=s' => \( my $avoid_regex      = '(affy|encode|multiz|phastCons|phyloP)' ),
    'ncp'       => \( my $not_check_parent = 0 ),
) or HelpMessage(1);

#----------------------------------------------------------#
# init
#----------------------------------------------------------#
my ( $site, $remote_base, $local_base );
{
    my ( $scheme, $auth, $path, $query, $frag ) = uri_split($main_url);
    $site        = $auth;
    $remote_base = $path;

    my ( $vol, $dirs, $file ) = File::Spec->splitpath($remote_base);
    my @dirs = grep {/[\w-]/} File::Spec->splitdir($dirs);

    $local_base = File::Spec->catdir(@dirs);
}

my $urlchecker = Urlcheck->new(
    site             => $site,
    remote_base      => $remote_base,
    local_base       => $local_base,
    not_check_parent => $not_check_parent,
    verbose          => 1,
);
print "URL checker opt:\n";
print Dump $urlchecker;

#----------------------------------------------------------#
# run
#----------------------------------------------------------#
printf "\nURL: %s\n",           $main_url;
printf "\nWORKING DIR: %s\n\n", $working_dir;

# Recursive walking
walking( $main_url, $urlchecker );

{
    # convert remote url to local path
    $urlchecker->convert_all;

    # Dump file as outputs
    my $yamlfile = join "_", grep {/[\w-]/} split /\//, $remote_base;
    $yamlfile = File::Spec->catfile( $working_dir, $yamlfile . '.yml' );
    DumpFile(
        $yamlfile,
        {   url_path  => $urlchecker->url_path,
            dir_to_mk => $urlchecker->dir_to_mk,
            cmdline   => $cmdline,
        }
    );
}

#----------------------------#
# subs in package main
#----------------------------#
sub walking {
    my $url        = shift;
    my $urlchecker = shift;

    return if $urlchecker->already_met($url);
    return if $urlchecker->add_url($url) != 1;

    # All these file types are dead ends
    return if $url =~ /\.(rar|7z|bz|zip|gz|xz|tgz)$/i;
    return if $url =~ /\.(gif|jpg|jpeg|png)$/i;
    return if $url =~ /\.(md5|txt|sql)$/i;
    return if $url =~ /\.(2bit|lav|axt|fa|fq|fasta|fastq|fas)$/i;
    return if $url =~ /\.(bb|nh|mod)$/i;
    return if $url =~ /$avoid_regex/i;

    if ( is_html($url) ) {
        my $mech = get_page_obj($url);
        return unless $mech;
        my @links = $mech->find_all_links;
        for my $link (@links) {

            # Apache html dir
            next if $link->text =~ /Parent Directory/i;

            my $link_url = $link->url_abs->as_string;
            print $link_url, "\n";
            walking( $link_url, $urlchecker );
        }
    }
}

sub is_html {
    my $url = shift;
    my ( $content_type, $document_length, $modified_time, $expires, $server ) = head($url);
    return 1 if !defined $content_type;
    return $content_type =~ /html/;
}

sub get_page_obj {
    my $url = shift;

    my $mech = WWW::Mechanize->new;
    eval { $mech->get($url); };
    warn $@, "\n" if $@;

    return $mech;
}

__END__
