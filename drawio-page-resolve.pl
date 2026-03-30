#!/usr/bin/env perl
# -----------------------------------------------------------------------------
# drawio-page-resolve.pl
#
# Resolve a diagram page inside a draw.io XML file by its name.
#
# USAGE:
#   perl drawio-page-resolve.pl FILE.drawio PAGE_NAME [MODE]
#
# ARGUMENTS:
#   FILE.drawio   Path to the draw.io XML file
#   PAGE_NAME     Name of the <diagram> to search for
#   MODE          Optional: 'index' (default) or 'id'
#
# BEHAVIOR:
#   - Searches all <diagram ...> elements in the XML
#   - Matches diagrams where attribute name="PAGE_NAME"
#   - Attribute order (name/id) does not matter
#
# OUTPUT (STDOUT):
#   index   → 1-based position of the matching diagram
#   id      → value of the diagram's id attribute
#
# ERROR HANDLING:
#   - If no matching page is found:
#       prints "-1" to STDOUT and exits with error
#
#   - If multiple pages share the same name:
#       prints "-2" to STDOUT and exits with error
#
#   - If MODE='id' but no id attribute exists:
#       prints "-1" to STDOUT and exits with error
#
#   - Error messages are written to STDERR
#
# EXAMPLES:
#   perl drawio-page-resolve.pl file.drawio "Page-1"
#   perl drawio-page-resolve.pl file.drawio "Page-1" index
#   perl drawio-page-resolve.pl file.drawio "Page-1" id
#
# NOTES:
#   - Default MODE is 'index' if not provided
#   - Designed for integration with LaTeX workflows
# -----------------------------------------------------------------------------
## drawio-page-resolver.pl
## Copyright 2026 Stefan Unrein
#
# This work may be distributed and/or modified under the
# conditions of the LaTeX Project Public License, either version 1.3
# of this license or (at your option) any later version.
# The latest version of this license is in
#   http://www.latex-project.org/lppl.txt
# and version 1.3 or later is part of all distributions of LaTeX
# version 2005/12/01 or later.
#
# This work has the LPPL maintenance status `maintained'.
#
# The Current Maintainer of this work is Stefan Unrein.
#
# This work consists of the files drawio.sty and
# drawio-page-resolver.pl

use strict;
use warnings;

my ($file, $wanted, $mode) = @ARGV;
$mode //= 'index';

die "usage: drawio-page-resolve.pl FILE.drawio PAGE_NAME [index|id]\n"
    unless defined $file && defined $wanted;

die "drawio-page-resolver: invalid mode '$mode' (expected 'index' or 'id')\n"
    unless $mode eq 'index' || $mode eq 'id';

open my $fh, '<', $file or die "cannot open $file: $!";

local $/;
my $xml = <$fh>;
close $fh;

my $index = 0; # increment index with every start of the loop
my @matches;

while ($xml =~ /<diagram\b([^>]*)>/g) {
    ++$index;
    my $attrs = $1;
    #print STDERR "Found diagram entry with parameters '$attrs' at index '$index\n";

    my %attr;
    while ($attrs =~ /\b([A-Za-z_:][A-Za-z0-9_.:-]*)="([^"]*)"/g) {

        #print STDERR "Found attribute '$1' with value '$2'\n";
        $attr{$1} = $2;
    }

    next unless exists $attr{name};
    next unless $attr{name} eq $wanted;

    #print STDERR "Pushing match with index '$index' and id '$attr{id}'\n";
    push @matches, {
        index => $index,
        id    => $attr{id},
    };
}

    print STDERR "Finished loop\n";

if (@matches == 0) {
    print "ERR:Page '$wanted' not found";
    exit 1;
}

if (@matches > 1) {
    print "ERR:Page '$wanted' is ambiguous (" . scalar(@matches) . " matches)";
    exit 1;
}

if ($mode eq 'index') {
    print "OK:" . $matches[0]{index};
}
else {
    if (defined $matches[0]{id}) {
        print "OK:" . $matches[0]{id};
    }
    else {
        print "ERR:Page '$wanted' has no id attribute";
        exit 1;
    }
}

exit 0;
