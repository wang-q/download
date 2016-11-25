#!/usr/bin/perl
use strict;
use warnings;
use autodie;

use Getopt::Long qw(HelpMessage);
use YAML qw(Dump Load DumpFile LoadFile);

use Path::Tiny;
use LWP::Simple;
use LWP::UserAgent;
use MCE;

#----------------------------------------------------------#
# GetOpt section
#----------------------------------------------------------#

=head1 NAME

download.pl - Download with LWP or generate a aria2 input file

=head1 SYNOPSIS

    perl download.pl [options]
      Options:
        --help          -?          brief help message
        --input         -i  STR     YAML created by list.pl
        --regex         -r  STR     regex filter what to download, default is [.]
        --aria2         -a          generate a aria2 input file
        --parallel          INT     parallel LWP download

    perl download.pl -i 19genomes_fasta.yml -a
    aria2c -x 9 -s 3 -c -i 19genomes_fasta.yml.txt

=cut

GetOptions(
    'help|?'    => sub { HelpMessage(0) },
    'input|i=s' => \( my $file_yaml ),
    'regex|r=s'  => \( my $path_regex = "." ),
    'aria2|a'    => \( my $aria2 ),
    'parallel=i' => \( my $parallel   = 4 ),
) or HelpMessage(1);

#----------------------------------------------------------#
# init
#----------------------------------------------------------#
my $dispatch  = LoadFile($file_yaml);
my $dir_to_mk = $dispatch->{dir_to_mk};
my $url_path  = $dispatch->{url_path};

#----------------------------#
# create dirs
#----------------------------#
# Files will locate in the same dir as the yaml file.
$file_yaml = path($file_yaml)->absolute;
my $base_dir = $file_yaml->parent->stringify;
for my $dir ( sort keys %{$dir_to_mk} ) {
    $dir = path( $base_dir, $dir )->stringify;
    path($dir)->mkpath;
}

my $aria2_file;
if ($aria2) {
    $aria2_file = $file_yaml . ".txt";
    path($aria2_file)->remove;
}

#----------------------------#
# parallel download
#----------------------------#
my @jobs;
for my $url ( sort keys %{$url_path} ) {
    my $path = $url_path->{$url};
    next unless $path =~ /$path_regex/;

    $path = path( $base_dir, $url_path->{$url} )->stringify;
    push @jobs, [ $url, $path ];
}

if ($aria2) {    # aria2
    for my $job (@jobs) {
        my ( $url, $path ) = @{$job};
        printf "* URL: %s\n" . "* LOCAL: %s\n", $url, $path;

        my $str;
        $str .= "$url\n";

        my $file = path($path);
        $str .= "  dir=" . $file->parent->stringify . "\n";
        $str .= "  out=" . $file->basename . "\n";

        open my $fh, '>>', $aria2_file;
        print {$fh} $str;
        close $fh;
    }

    print "\nRun something like the following command to start downloading.\n";
    print "aria2c -x 9 -s 3 -c -i $aria2_file\n";
}
else {    # LWP
    my $mce = MCE->new( chunk_size => 1, max_workers => $parallel, );

    $mce->foreach(
        \@jobs,
        sub {
            my ( $self, $chunk_ref, $chunk_id ) = @_;
            my ( $url, $path ) = @{ $chunk_ref->[0] };
            my $rc = get_file( $url, $path );
            printf "* No. %d\n", $chunk_id;
            printf "* URL: %s\n" . "* LOCAL: %s\n", $url, $path;
            printf "* RC: %s\n\n", $rc;
        }
    );
}

#----------------------------#
# subs
#----------------------------#
sub get_file {
    my $url      = shift;
    my $filename = shift;

    my $rc = mirror( $url, $filename );
    return $rc;
}

__END__
